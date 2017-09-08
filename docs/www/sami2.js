var $jQ = jQuery.noConflict();

// Example autocalc for BMI for the background form.

// The main purpose of this is to set up event handlers that calculate the
// value for BMI based on the form elements sbph, sbphu, sbpw and sbpwu
// (height, height units, weight and weight units, respectively). It's just an
// example, and hastily coded at that. It's also raw JavaScript without any
// concern for compatibility; if I were going to do this in a cross-platform
// way, I'd use a framework like jQuery that would handle that stuff for me.

$jQ( document ).ready( function() {

  // Get the first form element; for the SAMI forms, this will always be the
  // first form.

  var bgform = $jQ( "form#backgroundForm" )[0];

  if (bgform) {
    var flatInput = function( name ){
      return $jQ( "form#backgroundForm input[name='" + name + "']" );
    },
        radioSelected = function( name ){
          return $jQ(
            "form#backgroundForm input[name='" + name + "']:checked"
          )[0];
        },
        bmiCalc = function(){
          var htm = (radioSelected("sbphu").value == "i" ? 0.0254 : 0.01),
              wtm = (radioSelected("sbpwu").value == "p" ? 0.4535 : 1),
              ht = flatInput("sbph").val() * htm,
              wt = flatInput("sbpw").val() * wtm,
              bmi = wt / (ht * ht);
          if( ht > 0 && wt > 0 ) {
            flatInput("sbbmi").val( bmi.toFixed(1) );
          } else {
            flatInput("sbbmi").val( "" );
          }
          flatInput("sbbmivis").val( flatInput("sbbmi").val() );
        };
    flatInput("sbph").on( "change", bmiCalc );
    flatInput("sbpw").on( "change", bmiCalc );
    flatInput("sbphu").on( "change", bmiCalc );
    flatInput("sbpwu").on( "change", bmiCalc );
    bmiCalc();
  }
  if (bgform && bgform.newform) {
    $jQ( "input.yyyymmdd" ).datepicker( {
      showOn: "button",
      buttonImage: "calendar.png",
      buttonImageOnly: true,
      buttonText: "Select date",
      dateFormat: "yy-mm-dd",
      prevText: "Previous",
      nextText: "Next"
    } );
    // var make_abler = function( thingy ){
    //   console.log("Setting up '" + thingy + "'");
    //   var f = function(){
    //     var sect = $jQ( thingy + "switch" ),
    //         state = (y_element.value == "y");
    //     sect
    //       .find( ':input' )
    //       .prop( "disabled", state );
    //     sect.prop( "disabled", state );
    //   };
    //   f();
    //   for (var i = 0, ilen = bgform[thingy].length; i < ilen; i++) {
    //     bgform[thingy][i].onclick = f;
    //   }
    // };
    // // Set up some enablers.
    // make_abler( "sbfc" );
    // make_abler( "sbhco" );
    // make_abler( "sbmpa" );
    // make_abler( "sbmpc" );
    // make_abler( "sbmpht" );
    // make_abler( "sbmphc" );
    // make_abler( "sbmpas" );
    // make_abler( "sbmpmi" );
    // make_abler( "noidea7" );
    // make_abler( "sbmpd" );
    // make_abler( "noidea10" );
    // make_abler( "noidea12" );
  }

} );
