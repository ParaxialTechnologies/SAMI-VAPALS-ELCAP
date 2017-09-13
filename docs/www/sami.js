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
    var bmiCalc = function(){
      var ht = bgform.sbph.value * (bgform.sbphu.value == "i" ? 0.0254 : 0.01),
          wt = bgform.sbpw.value * (bgform.sbpwu.value == "p" ? 0.4535 : 1),
          bmi = wt / (ht * ht);
      if( ht > 0 && wt > 0 ) {
        bgform.sbbmi.value = bmi.toFixed(1);
      } else {
        bgform.sbbmi.value = "";
      }
      bgform.sbbmivis.value = bgform.sbbmi.value;
    },
        sbffrCalc = function(){
          var sbffr;
          if( bgform.sbfvc.value > 0.1 ) {
            sbffr = bgform.sbfev1.value / bgform.sbfvc.value * 100.0;
            bgform.sbffr.value = sbffr.toFixed(2);
            bgform.sbffrvis.value = sbffr.toFixed(1) + '%';
          } else {
            bgform.sbffrvis.value = "";
          }
        };
    // Assign the same onchange to the weight box.
    bgform.sbph.onchange = bmiCalc;
    bgform.sbpw.onchange = bmiCalc;
    // And to each of the radio buttons.
    for (var i = 0, len = bgform.sbphu.length; i < len; i++) {
      bgform.sbphu[i].onclick = bmiCalc;
    }
    for (var i = 0, len = bgform.sbpwu.length; i < len; i++) {
      bgform.sbpwu[i].onclick = bmiCalc;
    }
    // Oh. Yeah. And execute it since we have the form loaded.
    bmiCalc();
    bgform.sbfev1.onchange = sbffrCalc;
    bgform.sbfvc.onchange = sbffrCalc;
    sbffrCalc();
    // Get all the links, and go through them one by one.
    var tt = document.getElementsByTagName( "a" );
    for (var i = 0; i < tt.length; ++i) {
      // Check the class; we're looking for info-class links.
      var tt1 = tt[i].attributes.class;
      if (tt1 && tt1.value == "info") {
        // Grab the value.
        tt1 = tt[i].attributes.value;
        var html = tt1
            ? tt1.value
            : "<p><i>No information text specified.</i></p>";
        html = "<a href="#" class=\"closebox\"><img src=\"close.svg\"/></div>" + html;
        console.log( html );
        var newDiv = document.createElement( "div" );
        newDiv.setAttribute( "class", "infobox" );
        var boxid = tt[i].attributes.id + "box";
        newDiv.setAttribute( "id", boxid );
        newDiv.innerHTML = html;
        newDiv.onclick = function(){
          this.setAttribute( "display", "none" );
        }
        tt[i].parentNode.insertBefore( newDiv, tt[i] );
        tt[i].targetdiv = boxid;
        tt[i].onclick = function(e){
          var x = document.getElementById( this.targetdiv );
          console.log( e );
          x.style.left = e.pageX + "px";
          x.style.top = e.pageY + "px";
          x.style.display = "block";
          console.log( "x = " + x.style.left );
          console.log( "y = " + x.style.top );
        }
      }
    }
  }

} );
