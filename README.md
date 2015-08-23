# evie-perl
Evie in Perl

# How to build Docker image
```shell
% docker build -t evie-perl .
```

# How to run
```shell
% docker run -d --name my-evie -p 3000:3000 evie-perl
```

# How to create db
```sql
CREATE TABLE titles (`key` TEXT PRIMARY KEY, `title` TEXT);
```

# Usage
```shell
% curl -X GET evie:3000/match -d f="진짜사나이150510.mp4"
{"file":"Real Men - 2015-05-10.mp4","season":"2015","show":"Real Men"}%
```
