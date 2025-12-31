# BiocBuildDB

BiocBuildDB is an R package that provides tools for managing and
querying a database of Bioconductor build reports. These reports contain
information about the build status of Bioconductor packages across
different platforms and R versions.

## Data flow

Each day, the Bioconductor build reports are processed to generate
structured tables of build results. These tables are stacked to generate
a longitudinal record of build results available as parquet files. The
data flow for the entire process is outlined in the diagram below.

``` mermaid
flowchart TD
    %% =========================
    %% Phase A: Daily extraction
    %% =========================
    A[Bioconductor<br/>Daily Build Reports]
        -->|daily| B[Parse & Normalize<br/>Build Metadata]

    B -->|md5 hashed<br/>by build report| C1[info.csv]
    B -->|md5 hashed<br/>by build report| C2[build_summary.csv]
    B -->|md5 hashed<br/>by build report| C3[propagation_status.csv]

    %% =========================
    %% Phase B: Longitudinal stacking
    %% =========================
    C1 -->|append new report| D1[info.parquet<br/>partitioned by date]
    C2 -->|append new report| D2[build_summary.parquet<br/>partitioned by date]
    C3 -->|append new report| D3[propagation_status.parquet<br/>partitioned by date]

    %% =========================
    %% Storage layer
    %% =========================
    D1 --> E[(Object Storage\nS3 / GCS)]
    D2 --> E
    D3 --> E

    %% =========================
    %% Storage layer
    %% =========================
    E -->|Usage| U[BiocBuildDB R Package]
    E -->|Usage| DASH[Third party dashboards]
    E -->|Usage| ANALYSIS[Analytics]


    %% =========================
    %% Styling
    %% =========================
    classDef source fill:#eef,stroke:#446;
    classDef daily fill:#efe,stroke:#484;
    classDef parquet fill:#ffe,stroke:#aa4;
    classDef storage fill:#fdf6e3,stroke:#b58900;

    class A source;
    class C1,C2,C3 daily;
    class D1,D2,D3 parquet;
    class E storage;
```

## Installation

You can install the development version of BiocBuildDB from
[GitHub](https://github.com/) with:

``` r
# install.packages("BiocManager")
BiocManager("seandavi/BiocBuildDB")
```

## Basic Usage

See the vignettes for detailed examples on how to use BiocBuildDB to
query and analyze Bioconductor build reports.
