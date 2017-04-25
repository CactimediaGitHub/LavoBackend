(function ($) {
    $.deserialize = function (str, options) {
        var pairs = str.split(/&amp;|&/i),
            h = {},
            options = options || {};
        for(var i = 0; i < pairs.length; i++) {
            var kv = pairs[i].split('=');
            kv[0] = decodeURIComponent(kv[0]);
            if(!options.except || options.except.indexOf(kv[0]) == -1) {
                if((/^\w+\[\w+\]$/).test(kv[0])) {
                    var matches = kv[0].match(/^(\w+)\[(\w+)\]$/);
                    if(typeof h[matches[1]] === 'undefined') {
                        h[matches[1]] = {};
                    }
                    h[matches[1]][matches[2]] = decodeURIComponent(kv[1]);
                } else {
                    h[kv[0]] = decodeURIComponent(kv[1]);
                }
            }
        }
        return h;
    };

    $.fn.deserialize = function (options) {
        return $.deserialize($(this).serialize(), options);
    };
})(jQuery);

(function($) {
  $(document).ready(function() {
    var urlParts = document.URL.split('?');
    var queryString = urlParts[1] || '';
    var params = queryString ? $.deserialize(queryString) : { filter: {} };
    if (typeof params.filter === 'undefined') params.filter = {};

    function changeFilter(changedAttribute, newValue) {
      if (!newValue) {
        delete params.filter[changedAttribute];
      } else {
        params.filter[changedAttribute] = String(newValue);
      }

      var urlString = $.param(params);
      window.location.href = [urlParts[0], urlString].join('?');
    }

    $('[data-select]').each(function(index, e) {
      var $e = $(e);
      var filterName = $e.data('select');
      var $select = $('<select name="filter-' + filterName + '"></select>');
      var options = $e.data('options') || 'true;false';
      options = options.split(';');
      $select.append($('<option></option>'));
      for (var i = 0; i < options.length; i++) {
        var opt = options[i];
        var selected = (params.filter[filterName] === opt) ? 'selected="seLected"' : '';
        $select.append($('<option value="' + opt + '" ' + selected + '>' + opt + '</option>'));
      }
      $select.on('change', function(select) {
        var $select = $(select.target);
        var attribute = $select.attr('name').replace('filter-', '');
        var value = $select.val();
        changeFilter(attribute, value);
      });

      $e.append($select);
    });
  });
})(jQuery)
