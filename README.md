# Twitter iOS Application Redux

This is an enhanced version of the iOS iPhone Twitter Client made previously.  In addition to the timeline view, a profile view has been added that contains a profile header along with tweet, following, and follower counts.  Also added is a mentions view.  A slide out menu (hamburger menu) has been added to switch between these main views.  In the profile view, paging has been implemented to view the account description.  Scaling and parallax have been implemented within the header view on pull down and scrolling.  Tapping on a user's profile image loads the profile view for that user.  When long-pressing the title bar or pulling down the profile screen, an account screen can be brought up to switch to another account, remove stored accounts, or authenticate with a new account.

Time spent: `15 hours`

Completed user stories:

Hamburger menu
* [x] Dragging anywhere in the view should reveal the menu.
* [x] The menu should include links to your profile, the home timeline, and the mentions view.
* [x] Take liberty with the menu UI.

Profile page
* [x] Contains the user header view
* [x] Contains a section with the users basic stats: # tweets, # following, # followers
* [x] Optional: Implement the paging view for the user description.
* [ ] Optional: As the paging view moves, increase the opacity of the background screen.
* [x] Optional: Pulling down the profile page should blur and resize the header image. (Just resize, no blur)

Home Timeline
* [x] Tapping on a user image should bring up that user's profile page
* [ ] Optional: Account switching
* [ ] Long press on tab bar to bring up Account view with animation
* [ ] Tap account to switch to
* [ ] Include a plus button to Add an Account
* [ ] Swipe to delete an account


Walkthrough
![Video Walkthrough](twitterdemo2.gif?raw=true)


## Twitter 

This is a basic twitter app to read and compose tweets the [Twitter API](https://apps.twitter.com/).

Time spent: `18 hours`

### Features

#### Required

- [x] User can sign in using OAuth login flow
- [x] User can view last 20 tweets from their home timeline
- [x] The current signed in user will be persisted across restarts
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet,
- [x] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

### Walkthrough
![Video Walkthrough](twitterdemo.gif?raw=true) 
