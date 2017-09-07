// Example autocalc for BMI for the background form.

// The main purpose of this is to set up event handlers that calculate the
// value for BMI based on the form elements sbph, sbphu, sbpw and sbpwu
// (height, height units, weight and weight units, respectively). It's just an
// example, and hastily coded at that. It's also raw JavaScript without any
// concern for compatibility; if I were going to do this in a cross-platform
// way, I'd use a framework like jQuery that would handle that stuff for me.

document.addEventListener( "DOMContentLoaded", function(){

  // Get the first form element; for the SAMI forms, this will always be the
  // first form.

  var bgform = document.forms.backgroundForm;

  // If this is the background form . . .

  if (bgform) {
    bgform.sbph.onchange = function(){
      var ht = bgform.sbph.value * (bgform.sbphu.value == "i" ? 0.0254 : 0.01),
          wt = bgform.sbpw.value * (bgform.sbpwu.value == "p" ? 0.4535 : 1),
          bmi = wt / (ht * ht);
      if( ht > 0 && wt > 0 ) {
        bgform.sbbmi.value = bmi.toFixed(1);
      } else {
        bgform.sbbmi.value = "";
      }
      bgform.sbbmivis.value = bgform.sbbmi.value;
    };
    // Assign the same onchange to the weight box.
    bgform.sbpw.onchange = bgform.sbph.onchange;
    // And to each of the radio buttons.
    for (var i = 0, len = bgform.sbphu.length; i < len; i++) {
      bgform.sbphu[i].onclick = bgform.sbph.onchange;
    }
    for (var i = 0, len = bgform.sbpwu.length; i < len; i++) {
      bgform.sbpwu[i].onclick = bgform.sbph.onchange;
    }
  }
  if (bgform && bgform.newform) {
    var make_abler = function( thingy, y_element, disable_array ){
      console.log("Setting up '" + thingy + "'");
      var f = function(){
        var sect = document.getElementById( thingy + "switch" ),
            state = (y_element.value == "y");
        sect.classList.add( state ? "enabled" : "disabled" );
        sect.classList.remove( state ? "disabled" : "enabled" );
        for (var i = 0, len = disable_array.length; i < len; i++) {
          var element = bgform[disable_array[i]];
          if( typeof( element[0] ) == "undefined" ) {
            element.disabled = !state;
          } else {
            for (var j = 0, jlen = element.length; j < jlen; j++) {
              element[j].disabled = !state;
            }
          }
        }
      };
      f();
      for (var i = 0, ilen = bgform[thingy].length; i < ilen; i++) {
        bgform[thingy][i].onclick = f;
      }
    };
    // Set up some enablers.
    make_abler( "sbfc", bgform.sbfc, ["sbfcf", "sbfcm", "sbfcs"] );
    make_abler( "sbhco", bgform.sbhco, ["sbhcdod", "sbhcpbo"] );
    make_abler( "sbmpa", bgform.sbmpa, ["sbmpat"] );
    make_abler( "sbmpc", bgform.sbmpc, ["sbmpcw"] );
    make_abler( "sbmpht", bgform.sbmpht, ["sbmphtt", "sbmphtsw", "sbmphthv"] );
    make_abler( "sbmphc", bgform.sbmphc, ["sbmphct"] );
    make_abler( "sbmpas", bgform.sbmpas, ["sbmpasw", "sbmpast"] );
    make_abler( "sbmpmi", bgform.sbmpmi, ["sbmpmid", "sbmpmiw"] );
    make_abler( "noidea7", bgform.noidea7, ["noidea8"] );
    make_abler( "sbmpd", bgform.sbmpd, ["sbmpdw", "sbmpdt"] );
    make_abler( "noidea10", bgform.noidea10, ["noidea11"] );
    make_abler( "noidea12", bgform.noidea12, ["noidea13"] );
  }

} );
