I did this because I noticed two things in my GitHub contribution chart:

  1. Weekends are typically quiet, with the exception of an odd day here or
     there on personal projects that I don't host the git repo for myself.  Yay
     for healthy balances!

  2. Activity seemed higher at the leftmost edge, which was May 2020.  May was
     still quite busy at work with pandemic-related dev.  This made me wonder
     what my activity looked like earlier in 2020.  _[I only noticed
     afterwards, when tweaking styles for my `all.html`, that the reason it was
     cutoff at May is because my browser window was narrow and `overflow:
     hidden` is set on the SVG container.]_

So off I set on this diversion.

I found the endpoint for the contribution graph's partial by fiddling in the
dev tools on [my user page](https://github.com/tsibley):

    https://github.com/users/tsibley/contributions?from=2020-08-01&to=2021-02-25

I confirmed that I could fetch real data from prior years by adjusting the
query params.  I also noted that the date span is limited to a maximum of 1y,
which meant I couldn't fetch multiple years in one request.

The partial is some HTML with an embedded SVG.  The actual raw counts are
embedded as `data-count` attributes on the SVG elements for each day.  But the
SVG was unstyled, so you couldn't see the color scale.

Back to my user page I went, dev tools in hand, to find the CSS file containing
the contribution graph styles.  GitHub serves a source map for their minified
CSS, so it was easy to read in the dev tools.  Even better, though, the
minified CSS was a single easy file to fetch.  Loading it into the partial
page, formatting and layout was there, but color was still not.  Ah, some CSS
variables are missing.  Found those in another big minified file.  Presto.

This is going to work.  How far back do I want to fetch?  How about all the
way?

So, on a hunch that it was there, I looked up the year I created my GitHub
account by reading the API response for a user:

    curl -fsS https://api.github.com/users/tsibley

Bingo.  There's a `created_at` field.  I signed up in 2009.

With that in hand, I fetched the pages:

    for year in $(seq 2009 2021); do
        curl -fsS "https://github.com/users/tsibley/contributions?from=$year-01-01&to=$year-12-31" > $year.html;
    done
