# Tsurugi

Tsurugi is a purely open-source relational database system (RDB) developed with support from the Japanese government. It is rooted in community initiatives that initially began as volunteer study groups and receives significant backing from private companies (Nautilus Technologies/NEC), universities (Tokyo Institute of Technology/Keio University/Nagoya University/Osaka University), and research institutions (National Astronomical Observatory of Japan). Tsurugi represents the next generation of high-performance RDBs, created through collaboration among various companies and stakeholders. As an open-source project, it is available for use under the Apache 2.0 license, and commercial support options are also provided.

## Why "RDB" Now?

The common impression among average engineers often includes questions like, "Why stick with the old-fashioned RDB?" and "Isn't this technology becoming obsolete?" In reality, RDB technology continues to advance year after year. Nevertheless, integrating new technology into existing RDBs presents challenges due to innovation dilemmas and reduced competition in an oligopolistic environment. Incorporating new technology, especially in RDBs with commercial backing, can be quite challenging.

## Reduced Choices and Innovation Dilemmas

RDBs play a pivotal role as middleware in today's IT systems. In the early days, there were over 50 products, including experimental and specialized offerings. However, as of 2023, only a handful of RDBs remain under active development, such as Oracle RDB and SQL Server, alongside two open-source options, MySQL (MariaDB) and PostgreSQL. In such a landscape, it becomes challenging for existing incumbents to take aggressive steps, develop additional functions, or overhaul the fundamental architecture to stay competitive. Additionally, the pressure to maintain compatibility with existing features and expanding codebases is mounting. Consequently, integrating technological innovations into existing RDBs, especially those requiring dramatic architectural changes due to shifting environments, becomes exceedingly difficult.

## Significant Environmental Changes

The hardware landscape has seen profound changes since the introduction and expansion of RDBs. Historically, IT software, including RDBs, improved in tandem with hardware advancements, driven by Moore's law that continually miniaturized semiconductors and enhanced node output. However, since the 2010s, the limitations of Moore's law and the emergence of cloud architecture have altered the landscape. These changes have prompted a significant shift towards distributed processing. Tsurugi envisions an execution environment centered on rich computational resources and memory-based architecture, optimizing throughput in distributed clusters with multi-node configurations, and enhancing low-latency distributed processing with many-core processors and large-capacity memory. This environment differs significantly from the assumptions underlying traditional RDB architectures, which relied on scarce memory and disk-based systems. As a result, existing RDBs struggle to fully harness the performance potential of this modern environment.

## Motivation

The fundamental stance of advanced database developers and engineers in Japan aligns with the open-source philosophy: "Use what you have, create what you don't have." The belief is that if a next-generation RDB were released using open-source principles, there would be no need to reinvent the wheel. In the face of technological disparities and changing environments, it is believed that someone, somewhere, will create a solution. Waiting for such a solution, however, proved futile. Ultimately, the conclusion was reached that there was no RDB suitable for the current era readily available. This realization led to the decision: "Since there are no other options, why don't we create it ourselves?"

This marked the inception of a collaborative effort among middleware professionals, resulting in Tsurugi. Tsurugi is designed to cater to open-source-minded individuals who specialize in cutting-edge middleware solutions. The architecture is uncompromising, and extensibility is a core principle. From the outset, Tsurugi was built with a distributed processing model in mind, incorporating research findings from the past two decades within the database industry. Tsurugi's overarching aim is to provide "a freely usable RDB that aligns with the demands of the new era."

## Features of Tsurugi

### 1. Designed for a Many-Core/In-Memory Environment

Tsurugi envisions an environment with numerous cores where Moore's law has reached its limits. It assumes a substantial memory capacity as the execution platform. The contemporary server environment witnesses a continuous increase in core count alongside growing main memory capacity. This many-core and large-capacity memory server configuration resembles a miniaturized, sophisticated, ultra-low-latency distributed setup, with multiple small "servers" operating within a single server. Traditional RDB architectures, which rely on "few cores," "scarce memory, " and "disk-based storage, "are ill-suited for this environment. Even deploying a new server with ample cores and memory may not lead to scaling improvements, potentially resulting in increased contention for resources and diminished performance.
Tsurugi, on the other hand, is a Native-Distributed-RDB, purpose-built to fully leverage the capabilities of a finely-grained, ultra-low-latency distributed environment.

### 2. Ensuring Consistency

In the evolving middleware landscape, databases and storage have differentiated their roles. The primary function of an RDB is no longer mere storage. The mission is now about efficiently handling a multitude of data requests by harnessing the computational power of server hardware. For basic data handling tasks, NoSQL and key-value stores suffice. However, the unique value proposition of an RDB, which hinges on advanced semantics, centers around providing consistency—specifically, serializability. Tsurugi excels in delivering serializability while maintaining exceptionally high performance. In essence, it prioritizes serializability as the primary consistency model.

### 3. Simultaneous Use of Multiple Interfaces

In today's multifaceted landscape, databases serve diverse purposes and use cases, spanning digital transformation (DX), artificial intelligence (AI), Internet of Things (IoT), web services, legacy applications, business batch processing, and more. A single interface is insufficient to address these diverse needs. Tsurugi accommodates this complexity by offering a wide range of interfaces, including high-level Java APIs, low-level Java communication libraries, PostgreSQL compatibility, Web APIs, Dump/Load APIs, a Read-Eval-Print Loop (REPL), and a Serializable Key-Value Store (KVS) interface. Even when employing these interfaces simultaneously, Tsurugi ensures consistent handling.

### 4. Component-Based Architecture

Tsurugi departs from the monolithic RDB model and adopts a component-based architecture. Each component collaborates to function as an RDB, fostering code modularity and manageability. Moreover, each component operates independently, providing users with the flexibility to extend or add their own components when needed. Tsurugi also offers multiple integration points for linking with other components, ensuring adaptability to diverse requirements.

### 5. Excellence in Batch Processing and Long Transactions

A standout feature of Tsurugi is its Hybrid Concurrency Control mechanism, capable of concurrently running multiple independent Concurrency Control protocols to maintain consistency. It supports two key Concurrency Control protocols: "OCC" and "LTX," both of which offer serializability independently and in combination. LTX, in particular, is tailored for batch processing scenarios. For situations where batch processing is not required, OCC offers exceptional speed and efficiency. Thanks to this mechanism, Tsurugi exhibits outstanding batch processing performance compared to other RDBs, making it possible to seamlessly combine batch and online processing. This sets Tsurugi apart from older-generation RDBs where batch and RDB were deemed incompatible. 
Tsurugi even provides an open-source batch processing benchmark sample application, allowing users to experience its capabilities firsthand.

### 6. Developed as Open Source

Tsurugi is an open-source project licensed under the Apache License 2.0. It imposes no specific usage restrictions, making it freely available for use and extension. Commercial support options are also readily accessible.
