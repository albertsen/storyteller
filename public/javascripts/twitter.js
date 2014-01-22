function update_twitter_timeline() 
{
	url = "http://twitter.com/statuses/user_timeline/_albertsen.json?count=5&callback=?";
	$.getJSON(url, function(statuses) {
		statuses_elem = $(document.createElement("div"));
		statuses_elem.addClass("statuses")
		ul = $(document.createElement("ul"))
		statuses_elem.append(ul);
		$.each(statuses, function(i, s) {
			li = $(document.createElement("li"));
			status_url = "http://twitter.com/_albertsen/status/" + s.id
			text = s.text.replace(/(https?:\/\/[^ ;|\\*'"!,()<>]+\/?)/g,'<a href="$1">$1</a>')
			li.html(text + " <a class='date' href=\"" + status_url + "\">..."  + relative_time(s.created_at) + "</a>");
			ul.append(li);
		});
		content = $("#twitter .content");
		content.prepend(statuses_elem);
		content.fadeIn();
	});
}

function relative_time(time_value) {
  var values = time_value.split(" ");
  time_value = values[1] + " " + values[2] + ", " + values[5] + " " + values[3];
  var parsed_date = Date.parse(time_value);
  var relative_to = (arguments.length > 1) ? arguments[1] : new Date();
  var delta = parseInt((relative_to.getTime() - parsed_date) / 1000);
  delta = delta + (relative_to.getTimezoneOffset() * 60);
  if (delta < 60) {
    return 'vor weniger als einer Minute';
  } 
	else if(delta < 120) {
    return 'vor ungefähr einer Minute';
  } 
	else if(delta < (60*60)) {
    return ('vor ' + parseInt(delta / 60)).toString() + ' Minuten';
  } 
	else if(delta < (120*60)) {
    return 'vor ungefähr einer Stunde';
  } 
	else if(delta < (24*60*60)) {
    return 'vor ungefähr ' + (parseInt(delta / 3600)).toString() + ' Stunden';
  } 
	else if(delta < (48*60*60)) {
    return 'vor einem Tag';
  } 
	else {
    return ('vor ' + parseInt(delta / 86400)).toString() + ' Tagen';
  }
}