#!/bin/bash

mysql.server start >> log

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS reddit;"

echo "CREATE TABLE  \`authors\` 
  (\`id\` int(11) NOT NULL auto_increment,   
  \`name\` VARCHAR(32) NOT NULL default 'name',   
  \`flare\` VARCHAR(128) NOT NULL default 'flair',     
  PRIMARY KEY (\`id\`) );" > auhthor_script.sql

echo "CREATE TABLE  \`posts\` 
  (\`id\` int(11) NOT NULL auto_increment, 
  \`author\` VARCHAR(32) NOT NULL default 'author',
  \`title\` VARCHAR(256) NOT NULL default 'title',    
  \`nsfw\` CHAR(6) NOT NULL default 'FALSE',   
  \`stickied\` CHAR(6) NOT NULL default 'FALSE',   
  \`locked\` CHAR(6) NOT NULL default 'FALSE',   
  \`edited\` CHAR(6) NOT NULL default 'FALSE',   
  \`created\` CHAR(3) NOT NULL default 'NON',   
  \`retrieved\` CHAR(3) NOT NULL default 'NON',   
  \`num_comments\` int(11) NOT NULL default '0', 
  \`subreddit\` VARCHAR(64) NOT NULL default 'blank',    
  \`url\` VARCHAR(256) NOT NULL default 'https://reddit.com',  
  PRIMARY KEY (\`id\`) );" > post_script.sql

echo "CREATE TABLE  \`subreddits\` 
  (\`id\` int(11) NOT NULL auto_increment,   
  \`name\` VARCHAR(64) NOT NULL default 'blank',     
  PRIMARY KEY (\`id\`) );" > sub_script.sql

mysql -uroot -D "reddit" -e "DROP TABLE IF EXISTS authors;"
mysql -uroot -D "reddit" -e "SOURCE auhthor_script.sql;"
insert_authors="INSERT INTO authors (name, flare) VALUES "
./parse_data_tosql.sh "./data/author_data.csv" "${insert_authors}"

mysql -uroot -D "reddit" -e "DROP TABLE IF EXISTS posts;"
mysql -uroot -D "reddit" -e "SOURCE post_script.sql;"
insert_posts="INSERT INTO posts (author, title, nsfw, stickied, locked, edited, created, retrieved, num_comments, subreddit, url) VALUES "
./parse_data_tosql.sh "./data/post_data.csv" "${insert_posts}"

mysql -uroot -D "reddit" -e "DROP TABLE IF EXISTS subreddits;"
mysql -uroot -D "reddit" -e "SOURCE sub_script.sql;"
insert_subreddits="INSERT INTO subreddits (name) VALUES "
./parse_data_tosql.sh "./data/sub_data.csv" "${insert_subreddits}" 

rm auhthor_script.sql
rm post_script.sql
rm sub_script.sql

mysql.server stop >> log