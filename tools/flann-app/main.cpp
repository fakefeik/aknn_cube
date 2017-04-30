#include <iostream>
#include <fstream>
#include <functional>
#include <math.h>

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
        dist += (first[i] - second[i])*(first[i] - second[i]);
    return sqrt(dist);
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

    index.knnSearch(query, indices, dists, nNeighbours, SearchParams(0));
    save_to_file(indices, filename, "result");

    delete[] indices.ptr();
    delete[] dists.ptr();
}

void makeInsert(ofstream &file, Matrix<float> data, string table)
{
    string sql = R"(

DROP TABLE IF EXISTS )" + table + R"(;

CREATE TABLE )" + table + R"( (
    v integer[]
);

INSERT INTO )" + table + R"( VALUES
)";

    file << sql;
    for (int i = 0; i < data.rows; i++)
    {
        file << "('{";
        for (int j = 0; j < data.cols - 1; j++)
            file << data[i][j] << ",";
        file << data[i][data.cols - 1] << "}')" << ((i == data.rows - 1) ? ";" : ",") << endl;
    }
}

void makeSqlScript(Matrix<float> dataset, Matrix<float> query, const char *filename)
{
    ofstream file;
    file.open(filename);

    makeInsert(file, dataset, "dataset");
    makeInsert(file, query, "query");
}

int main(int argc, char **argv)
{
    int nn = 1;
    Matrix<float> dataset;
    Matrix<float> query;
    load_from_file(dataset, "dataset.h5","dataset");
    load_from_file(query, "dataset.h5","query");

    cout << "brute.time: " << timeit([&]() -> void { knnSearch("result.brute.hdf5", dataset, query, nn, LinearIndexParams()); }) << " s" << endl;
    cout << "brute.totalDistance: " << totalDistance("result.brute.hdf5", dataset, query, nn) << endl;

    cout << "kdTree.time: " << timeit([&]() -> void { knnSearch("result.hdf5", dataset, query, nn, KDTreeIndexParams(4)); }) << " s" << endl;
    cout << "kdTree.totalDistance: " << totalDistance("result.hdf5", dataset, query, nn) << endl;

    makeSqlScript(dataset, query, "sift_to_postgres.sql");

    delete[] dataset.ptr();
    delete[] query.ptr();

    return 0;
}
