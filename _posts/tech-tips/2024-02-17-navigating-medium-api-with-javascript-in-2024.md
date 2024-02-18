---
excerpt: "Leverage the Medium API in JavaScript to publish a post to medium.com, and retrieve a list of all (published) posts for a user."
title: "Navigating Medium API with JavaScript in 2024"
date: "2024-02-17 19:07:00 -0500"
categories:
  - tech-tips
tags:  # up to 5, compatible with https://medium.com/explore-topics
  - medium-api
  - graphql
  - programming
  - javascript
  - npm-package
dev_to:
  id: 1764341
  tags:  # up to 4, compatible with https://dev.to/tags
  - medium
  - graphql
  - javascript
  - webdev
---

{% include tech-tips-head-notice.html %}

## Background 

I'm trying to integrate Medium blogging into my personal site at *myname.com*.

That is, I'm trying to automate the process of publishing an article on my personal blog, and have the contents of the Jekyll-based markdown post -- a `.md` file -- be posted to the two other blogging sites I'm currently signed up on, [`medium.com`](https://medium.com) and [`dev.to`](https://dev.to).

Towards that end, I tried to search online to see if there is such as a thing as a Medium API that allows me to:

* Publish and/or update a post for a user
* Retrieve a list of posts for a user

Turns out, only the first point is currently possible via the [Official Medium API](https://developers.medium.com/), and that too, it's only *partially* satisfied -- there is currently no route via the API to update a post on a Medium. One can only **create** a new post on Medium via the API, but that's about it.

With the Official [**Medium API**](https://github.com/Medium/medium-api-docs) as it stands -- which is no longer supported or maintained by the Medium team -- one can only retrieve user info and create a post, they cannot do anything much more useful than that, for example it is not possible to retrieve a list of a user's posts via the API.

### How to Auto-Update a Medium Post

This is slightly tangential to the matter, but I haven't expressed my discontent with not being able to automate the updating of a post on Medium via an API. I fooled around this with their API -- for example using an HTTP `PUT` request - for way too long, and didn't get anywhere with that at all. It's a real shame that we can only publish new posts via the API, and that it's not possible to update an existing post via an API.

In fact, this proved the impetus or drive for me to publish an online web tool that easily translates posts from *markdown* to *medium*, which I have published on my website: 

> [https://ritviknag.com/markdown-to-medium](https://ritviknag.com/markdown-to-medium)


I made this above tool for myself, so I can take my personal blog posts, written in `.md` files, paste them in there and copy the output to Medium when using the editor to update an existing post.

---

Anyway, slight detour there...

All this to say that I was not able to find a solution via the API that worked for me, to list all the posts under a given user. The reason for this is purely for automation purposes, such that whenever I change a blog post -- or `.md` file -- on my website, I want to publish a new post to Medium, but *only* if there is not already an existing post with that same title. So basically, I want to avoid re-publishing a post every time I make an update to it -- if that's even possible!

## My Search

My search led me to Google search for something along the lines of "**medium api get all user posts**", which led me more or less to this somewhat informative article on StackOverflow:

> [https://stackoverflow.com/q/36097527/10237506](https://stackoverflow.com/q/36097527/10237506)

As the accepted answer says, the Medium API is only intended for *Publishing* and is not intended to retrieve posts.

A workaround that is suggested is to simply use the RSS feed that Medium offers, as such:

> `https://medium.com/feed/@username`

For example, here is the RSS feed for my user:

> [https://medium.com/feed/@ritviknag](https://medium.com/feed/@ritviknag)

One can simply get the RSS feed via `GET`, then if it's needed in JSON format just use an NPM module like `rss-to-json` and we're good to go.

However, there is an issue with this approach, as another answer in the same SO post confirms:

> [...] has a limit of the **latest 10 posts**.

So, there is a limit of only retrieving 10 posts for a given user using the RSS feed option.

Looks like we need another solution!

## Unofficial Medium API

I would be remiss if I didn't mention an alternate approach.

There is an **Unofficial** Medium API that someone has come up with. This is the link to it below:

> [https://mediumapi.com](https://mediumapi.com)

Unfortunately, it's not an insignificant commitment to sign up with that API. Take a look below:

![Unofficial Medium API Subscription](/assets/images/medium-api-sub.png)

As noted, there appears to be a subscription tier for using that API. 

If I, as a developer, want to build an API wrapper around the Medium SDK to retrieve a User's posts, using this option I would be forced into:

* Create a RapidAPI key for `mediumapi.com`, or directing users of the library to sign up on *another* site and acquire a RapidAPI key for requests to `mediumapi.com`.
* Rate limiting my library at **150 requests / month**, assuming I want to hardcode and provide users with my RapidAPI key, in order to provide convenience and promote adoption of said library.

In short, this is likewise a disaster, albeit of different proportions. There is **no way** I can use a third-party, unofficial API, even though I have personally tested out this API endpoint and confirmed that it returns the correct and desired data.

Thus, the unavoidable road to the ***DIY project***, begins...

## The "Eureka!" Moment

To me, the lightbulb went off, when I was just bored and staring at a random Medium user's profile, and I had Chrome Developer tools open and was just browsing casually through the `Network` tab. 

The `graphql` endpoints, in particular, stood out to me:

![Chrome Dev GraphQL](/assets/images/chrome-dev-graphql.png){: height="200%"}

If curious, the URL to that is `https://medium.com/_/graphql`, and it's an HTTP `POST` request that gets sent.

Shortly after, I fired up Google search again and this time inputted keywords "**how to use medium api graphql to fetch all user posts**".

The result was this highly informative post on using Medium's GraphQL endpoint to retrieve Medium posts for a user:

> [https://medium.com/@mike820324/web-crawler-getting-medium-post-a6e52fd36fd6](https://medium.com/@mike820324/web-crawler-getting-medium-post-a6e52fd36fd6)

I decided to implement the same logic in the JavaScript (Node.js + TypeScript) library I was writing, with an intent to publish as an NPM package to [`npmjs.com`](https://npmjs.com/).

The hardest part for me was how to:

* Modify the GraphQL query to only return user post titles
* Paginate through the results, as GraphQL appears to have a limit of `25` results (posts) per request.

I managed to figure that out, even though it took me a long while.

By the way, I adapted the code from [a fork of the Medium SDK for Node.js](https://github.com/redco/medium-sdk-nodejs).

I made my own changes, and a ***lot*** of updates along the way.

Simply said, this was the very first *TypeScript NPM package* I had ever written. So there was a lot of learning curve.

## The Result

The work was split into a few main parts:
* Porting over existing Medium SDK code from *Node.js* to *TypeScript*.
* The hurdle that come with publishing a TypeScript NPM package, such as setting up `tsconfig.json` to allow support for [both ESM and CommonJS syntax](https://www.sensedeep.com/blog/posts/2021/how-to-create-single-source-npm-module.html) simultaneously.
* Integrating pagination and GraphQL into the codebase.
* Best practices for NPM projects in TypeScript, such as setting up code quality checks and CI/CD automation -- such as publishing package to a registry (NPM) automatically.

This project is the direct result of my hard work and effort:

[https://github.com/rnag/medium-sdk-ts](https://github.com/rnag/medium-sdk-ts)

Below is the package on the NPM registry:

[https://www.npmjs.com/package/medium-sdk-ts](https://www.npmjs.com/package/medium-sdk-ts)

### Install

The package can be installed with [npm](https://www.npmjs.com/), or a package manager of choice:

```sh
npm i medium-sdk-ts
```

### Import

The library supports importing via the newer, more modern *ES Module (ESM)* syntax prevalent in TypeScript code:

```ts
import {
  MediumClient,
  PostContentFormat,
  PostPublishStatus,
} from 'medium-sdk-ts';
```

Or, for *CommonJS* syntax in Node.js, using `require`: 

```js
const {
    MediumClient,
    PostContentFormat,
    PostPublishStatus,
} = require('medium-sdk-ts');
```

### Usage

Now create a client for the **Medium SDK**:

```ts
// Access Token is optional, can also be set
// as environment variable `MEDIUM_ACCESS_TOKEN`
const medium = new MediumClient('YOUR_ACCESS_TOKEN');
```

Retrieve User Details:

```ts
const user = await medium.getUser();
console.log(`User: ${JSON.stringify(user, null, 2)}`);
```

Publish a new *Draft Post* under your user:

```ts
const post = await medium.createPost({
    // Only `title` and `content` are required to create a post
    title: 'A new post',
    content: '<h1>A New Post</h1><p>This is my new post.</p>',
    // Optional below
    contentFormat: PostContentFormat.HTML,   // Defaults to `markdown`
    publishStatus: PostPublishStatus.DRAFT,  // Defaults to `draft`
    // tags: ["my", "tags"],
    // canonicalUrl: "https://my-url.com",
});

console.log(`New Post: ${JSON.stringify(post, null, 2)}`);
```

Retrieve a User's Published Posts (using GraphQL endpoint, which does not require an access token):

```ts
// Get User's Published Posts
const posts = await medium.getPosts('@username');
console.log(`User Post: ${JSON.stringify(posts, null, 2)}`);
```

Or, to simply retrieve the user's post titles only -- note that this results in a slightly more simplified GraphQL query being sent:

```ts
// Get User's Published Posts (Title Only)
const postTitles = await medium.getPostTitles('@username');
console.log(`User Post Titles: ${JSON.stringify(postTitles, null, 2)}`);
```

That's all for now!

I hope this post was informative. Feel free to play around with this NPM package I have published.

Again, here is the source code for it: [https://github.com/rnag/medium-sdk-ts](https://github.com/rnag/medium-sdk-ts)

If this library has proved useful in your automation efforts, please let me know via the comments down below, and feel free to also **star** the project on GitHub if you'd like.

As mentioned, this is my first-ever TypeScript library package I have published to NPM, so I would appreciate the support or feedback on it -- do certainly let me know if there's anything else I can improve on it.
