// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .
$(function () {
  if ($('#stock_watchlist_table').length > 0) {
    setTimeout(updatePrices, 10000);
  }
});

function updatePrices() {
  var params = null;
  if ($('#filter_investment').is(':checked')) {
    params='filter_investment=' + $('#filter_investment').attr('value');
  }

  if ($('#filter_trading').is(':checked')) {
    if (params != null) {
      params = params + '&';
    }
    params='filter_trading=' + $('#filter_trading').attr('value');
  }

  $.getScript('/stock_watchlists.js?filter_investment=' + filter_investment);
  setTimeout(updatePrices, 10000);
}
