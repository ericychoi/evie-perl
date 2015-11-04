# evie-perl
A simple web service that will return a English name for a given Korean TV show file.  You supply a filename, a JSON
with its English name and season and the new filename (in English) will be returned.

I built this to organize my Korean TV show collection, and to help [Plex](https://plex.tv/) recognize the files.

This is to be used with my [file watcher](https://github.com/ericychoi/evie).

Uses a sqlite3 dbfile, so in order to add more data, you need to add data into it.

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

# Insert
echo 'insert into titles values ("중화대반점", "The Chinese Restraunt");' | sqlite3 evie-perl/data/titles.db
echo 'select * from titles;' | sqlite3 evie-perl/data/titles.db # confirm

# Usage
```shell
% curl -X GET evie:3000/match -d f="진짜사나이150510.mp4"
{"file":"Real Men - 2015-05-10.mp4","season":"2015","show":"Real Men"}%
```
