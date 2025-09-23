#!/bin/bash

total_requests=$(wc -l < access.log)
unic_ip=$(awk '{arr[$1] = 1} END {print length(arr)}' access.log)

{
    echo "Отчет о логе веб-сервера"
    printf '=%.0s' {1..24}
    echo

    echo "Общее количество запросов:	$total_requests"
    echo "Количество уникальных IP-адресов:	$unic_ip"

    echo
    echo "Количество запросов по методам:"
    awk '{
            gsub(/"/, "", $6)
            split($6, parts, " ")
            method = parts[1]
            count[method]++
        }
        END {
            for (m in count) {
                print "   " count[m], m
            }
        }' access.log | sort -k2 -nr

    echo
    awk '{
            url = $7
            urls[url]++
         }
         END {
             max_count = 0
             most_popular_url = ""
             for (url in urls) {
                 if (urls[url] > max_count) {
                     max_count = urls[url]
                     most_popular_url = url
                 }
             }
             print "Самый популярный URL:" "   " max_count, most_popular_url
         }' access.log
} > report.txt

echo "Отчёт сохранён в файл report.txt"