#include <iostream>
#include <fstream>
#include <functional>

#include <flann/flann.hpp>
#include <flann/io/hdf5.h>

using namespace std;
using namespace flann;

double timeit(function<void()> f)
{
    auto begin = clock();
    f();
    auto end = clock();
    return double(end - begin) / CLOCKS_PER_SEC;
}

double distance(float *first, float *second, size_t len = 128)
{
    auto dist = 0.0;
    for (auto i = 0; i < len; i++)
        dist += abs(first[i] - second[i]);
    return dist;
}

double totalDistance(string resultFile, Matrix<float> dataset, Matrix<float> query, int nNeighbours)
{
    auto totalDistance = 0.0;
    Matrix<int> result;
    load_from_file(result, resultFile, "result");

    for (auto i = 0; i < result.rows; i++)
        for (auto j = 0; j < nNeighbours; j++)
            totalDistance += distance(query[i], dataset[result[i][j]]);

    return totalDistance/(result.rows*nNeighbours);
}

void knnSearch(string filename, Matrix<float> data, Matrix<float> query, int nNeighbours, IndexParams params)
{
    Matrix<int> indices(new int[query.rows*nNeighbours], query.rows, nNeighbours);
    Matrix<float> dists(new float[query.rows*nNeighbours], query.rows, nNeighbours);

    Index<L2<float>> index(data, params);
    index.buildIndex();

    index.knnSearch(query, indices, dists, nNeighbours, SearchParams(128));
    save_to_file(indices, filename, "result");

    delete[] indices.ptr();
    delete[] dists.ptr();
}

void makeInsert(ofstream &file, Matrix<float> data, string table)
{
    string sql = R"(

DROP TABLE IF EXISTS )" + table + R"(;

CREATE TABLE )" + table + R"( AS
    SELECT cube(vector) AS c FROM (VALUES
)";

    file << sql;
    for (int i = 0; i < data.rows; i++)
    {
        file << "\t\t(array[";
        for (int j = 0; j < data.cols - 1; j++)
            file << data[i][j] << ", ";
        file << data[i][data.cols - 1] << "])" << ((i == data.rows - 1) ? "\n\t) vectors(vector);" : ",") << endl;
    }
}

void makeSqlScript(Matrix<float> dataset, Matrix<float> query, const char *filename)
{
    ofstream file;
    file.open(filename);

    makeInsert(file, dataset, "dataset");
    makeInsert(file, query, "query");
}

void prettyPrint(Matrix<float> data, const char *filename)
{
    ofstream file;
    file.open(filename);
    for (int i = 0; i < data.rows; i++)
    {
        for (int j = 0; j < data.cols; j++)
            file << data[i][j] << ' ';
        file << endl;
    }
}

int main(int argc, char **argv)
{
    int nn = 3;
    Matrix<float> dataset;
    Matrix<float> query;
    load_from_file(dataset, "sift10K.h5","dataset");
    load_from_file(query, "sift10K.h5","query");

    cout << "brute.time: " << timeit([&]() -> void { knnSearch("result.brute.hdf5", dataset, query, nn, LinearIndexParams()); }) << " s" << endl;
    cout << "brute.totalDistance: " << totalDistance("result.brute.hdf5", dataset, query, nn) << endl;

    cout << "kdTree.time: " << timeit([&]() -> void { knnSearch("result.hdf5", dataset, query, nn, KDTreeIndexParams(4)); }) << " s" << endl;
    cout << "kdTree.totalDistance: " << totalDistance("result.hdf5", dataset, query, nn) << endl;

    prettyPrint(dataset, "dataset.txt");
    prettyPrint(query, "query.txt");
    makeSqlScript(dataset, query, "sift_to_postgres.sql");

    delete[] dataset.ptr();
    delete[] query.ptr();

    return 0;
}
