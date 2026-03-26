(function(){
  // Ensure apex object exists
  if (typeof apex === 'undefined') window.apex = {};

  // Initialize increaseDecrease only once
  if (!apex.increaseDecrease) {
    apex.increaseDecrease = {
      inc: function(itemId){
        var hidden = document.getElementById(itemId);
        var disp = document.getElementById('disp_' + itemId);
        var current = parseInt(hidden?.value || disp?.value || '0', 10) || 0;
        var next = current + 1;

        if(hidden) hidden.value = next;
        if(disp) disp.value = next;

        if(hidden){
          var ev = new Event('change', { bubbles: true });
          hidden.dispatchEvent(ev);
        }
      },
      dec: function(itemId){
        var hidden = document.getElementById(itemId);
        var disp = document.getElementById('disp_' + itemId);
        var current = parseInt(hidden?.value || disp?.value || '0', 10) || 0;
        var next = current - 1;
        if(next < 0) next = 0;

        if(hidden) hidden.value = next;
        if(disp) disp.value = next;

        if(hidden){
          var ev = new Event('change', { bubbles: true });
          hidden.dispatchEvent(ev);
        }
      }
    };
  }

  // Global wrapper functions called by buttons
  window.incValue = function(itemId){
    apex.increaseDecrease.inc(itemId);
  };

  window.decValue = function(itemId){
    apex.increaseDecrease.dec(itemId);
  };
})();
