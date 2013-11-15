function Carousel(){
  this.tweetIds = [];
}

Carousel.prototype = {
  nextTweetId: function() {
    if (this.tweetIds.length == 0) {
      var t = this;
      $.ajax({
        async: false,
        url: "/tweet_ids",
        dataType: "json",
        success: function(data) {
          t.tweetIds = data;
        }
      });
    }
    return this.tweetIds.shift();
  },

  displayTweet: function() {
    var tweetBox = $('#tweet-box');
    var previousTweet = tweetBox.children()[0];
    var nextTweetId = this.nextTweetId();
    twttr.widgets.createTweet(
      nextTweetId,
      tweetBox[0],
      null,
      { align: 'center' }
    );
    if (previousTweet != null) { previousTweet.remove(); }
  },

  start: function() {
    var t = this;
    t.displayTweet();
    setInterval(function(){ t.displayTweet() }, 12000);
  }
}

function startCarousel() {
  var carousel = new Carousel();
  carousel.start();
}

window.onload = startCarousel;
