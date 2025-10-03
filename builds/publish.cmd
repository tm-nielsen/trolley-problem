cd builds/web
if exist trolley_problem.html if exist index.html del index.html
if exist trolley_problem.html ren trolley_problem.html index.html

butler push . klungore/trolley-problem:web

cd ../windows
butler push . klungore/trolley-problem:windows