// A few things about this.
//
// First, this leans pretty heavily on jQuery, but I'm running it in
// noConflict() mode because I'm not sure what JavaScript libraries we're going
// to be using down the line. Given that this is the first real web-based Vista
// project that we're doing, this just seemed prudent.
//
// Second, you'll note that this does no form validation whatsoever at the
// moment. Mumps is both a programming language and the database engine, and
// thus it should specify *all* the business logic (just as you might with a
// proper SQL database). Later on, we'll work out a way to encode that logic
// and pass it to the JavaScript so that validation can happen in the browser,
// but for now, the server needs to do it old-school.
//
// Third, you'll note that the -switch regions are toggled on and off with a
// .disabled class, which dims the text to a light grey. This could have been
// done with the CSS inherit property so that .disabled could just be set on
// the parent property, but we don't know whether any of the text in these
// regions will be highlighted in a different color or whatnot in the future,
// so we're using an explicit class so that any of their "normal" properties
// will be preserved.
//
// (My thanks to Domenic DiNatale, who knows JavaScript a lot better than I.)
//
// ---ven/mcglk

var $jQ = jQuery.noConflict();

$jQ( document ).ready( function() {

  // Get the first form element; for the SAMI forms, this will always be the
  // first form.

  var bgform = $jQ( "form#backgroundForm" )[0],
      msinyear = 31557600000.0, // Milliseconds in one year.
      switchon = function(container){
        var obj = $jQ(container);
        // console.log( "enabling %o", container );
        obj.removeClass("disabled");
        obj.find(".disabled").each( function(){
          if (this.id.match(/-n?switch/)) { return; }
          $jQ(this).removeClass("disabled");
        });
        obj.find("input, select, textarea").each( function(){
          if (this.name.match(/-vis$/)) { return; }
          $jQ(this).prop("disabled", false);
        });
      },
      switchoff = function(container){
        var obj = $jQ(container);
        // console.log( "disabling %o", container );
        obj.addClass("disabled");
        obj.find().addClass("disabled");
        obj.find("input, select, textarea").prop("disabled", true);
      },
      switcher = function(){
        var control = $jQ(this).attr("switch");
        var ischecked = $jQ(this).is(":checked");
        var containername = "[id^='" + this.name + "-switch']"
        var container = $jQ(containername);
        var ncontainername = "[id^='" + this.name + "-nswitch']";
        var ncontainer = $jQ(ncontainername);
        if (container.length > 0) {
          if (control == "y" && ischecked) {
            switchon( container );
          } else {
            switchoff( container );
          }
        }
        if (ncontainer.length > 0) {
          if (control != "y" && ischecked) {
            switchon( ncontainer );
          } else {
            switchoff( ncontainer );
          }
        }
      };

    // The I-ELCAP date format.
    $jQ( "input.ddmmmyyyy" ).datepicker( {
      showOn: "button",
      buttonImage: "see/calendar.png",
      buttonImageOnly: true,
      buttonText: "Select date",
      dateFormat: "dd/M/yy"
    } );
    // ISO date format, when we get around to that.
    $jQ( "input.yyyymmdd" ).datepicker( {
      showOn: "button",
      buttonImage: "see/calendar.png",
      buttonImageOnly: true,
      buttonText: "Select date",
      dateFormat: "yy-mm-dd"
    } );

  if (bgform) {
    var calculateBMI = function( htInMeters, wtInKilograms ) {
          if( htInMeters > 0 && wtInKilograms > 0 ) {
            var areaInSquareMeters = htInMeters * htInMeters,
                bmi = wtInKilograms / areaInSquareMeters;
            return bmi;
          } else {
            return undefined;
          }
        },
        bmiCalc = function(){
          var uin = 0.0254, // unit: one inch expressed in meters
              ucm = 0.01,   // unit: one centimeter expressed in meters
              ulb = 0.4535, // unit: one pound expresssed in kilograms
              ukg = 1,      // unit: one kilogram expressed in kilograms
              htm = ($jQ("[name='sbphu']:checked").val() == "i" ? uin : ucm),
              wtm = ($jQ("[name='sbpwu']:checked").val() == "p" ? ulb : ukg),
              ht = $jQ("[name='sbph']").val() * htm,
              wt = $jQ("[name='sbpw']").val() * wtm,
              bmi = calculateBMI(ht,wt);
          if( bmi ) {
            $jQ("[name='sbbmi']").val( bmi.toFixed(1) );
          } else {
            $jQ("[name='sbbmi']").val( "" );
          }
          $jQ("[name='sbbmivis']").val( $jQ("[name='sbbmi']").val() );
        },
        sbffrCalc = function(){
          var sbffr;
          if( $jQ("[name='sbfvc']").val() > 0.1 ) {
            sbffr = (
              $jQ("[name='sbfev1']").val() / $jQ("[name='sbfvc']").val()
                * 100.0
            );
            $jQ("[name='sbffr']").val( sbffr.toFixed(2) );
            $jQ("[name='sbffrvis']").val( sbffr.toFixed(1) + '%' );
          } else {
            $jQ("[name='sbffrvis']").val( "" );
          }
        },
        sbsdlcyyCalc = function(){
          var today = new Date(),
              quitYear, quitMonth, quitDay, quitDate, since;
          quitYear = parseInt($jQ("[name='sbsdlcy']").val());
          quitMonth = parseInt($jQ("[name='sbsdlcm']").val());
          quitDay = parseInt($jQ("[name='sbsdlcd']").val());
          if (quitYear && quitMonth && quitDay) {
            quitMonth--;
          } else if (quitYear && quitMonth && !quitDay) {
            quitMonth--;
            quitDay = 1;
          } else if (quitYear && !quitMonth && quitDay) {
            quitMonth = today.getMonth();
          } else if (!quitYear && quitMonth && quitDay) {
            quitYear = today.getFullYear();
          } else if (quitYear && !quitMonth && !quitDay) {
            quitMonth = today.getMonth();
            quitDay = today.getDate();
          } else if (!quitYear && !quitMonth && quitDay) {
            quitYear = today.getFullYear();
            quitMonth = today.getMonth();
          } else if (!quitYear && quitMonth && !quitDay) {
            quitYear = today.getFullYear();
            quitDay = 1;
          } else if (!quitYear && !quitMonth && !quitDay) {
            $jQ("[name='sbsdlcy-vis']").val("");
            return;
          }
          quitDate = new Date(quitYear, quitMonth, quitDay);
          since = today - quitDate;
          if (since < 0) {
            $jQ("[name='sbsdlcy-vis']").val("");
            return;
          }            
          since /= msinyear;
          $jQ("[name='sbsdlcy-vis']").val( since.toFixed(1) );
        },
        sbntpyCalc = function(){
          var dpw = $jQ("[name='sbcdpw']").val(),
              ppd = $jQ("[name='sbcppd']").val(),
              yrs = $jQ("[name='sbcdur']").val(),
              tpy;
          if (dpw && ppd && yrs) {
            tpy = (ppd * dpw / 7.0) * yrs;
            $jQ("[name='sbntpy-vis']").val(tpy.toFixed(1));
            $jQ("[name='sbntpy']").val(tpy.toFixed(1));
          } else {
            $jQ("[name='sbntpy-vis']").val("");
            $jQ("[name='sbntpy']").val("");
          }
        };
    $jQ("[name='sbph']").on( "change", bmiCalc );
    $jQ("[name='sbpw']").on( "change", bmiCalc );
    $jQ("[name='sbphu']").on( "change", bmiCalc );
    $jQ("[name='sbpwu']").on( "change", bmiCalc );
    bmiCalc();
    $jQ("[name='sbfev1']").on( "change", sbffrCalc );
    $jQ("[name='sbfvc']").on( "change", sbffrCalc );
    sbffrCalc();
    $jQ("[name='sbsdlcd']").on( "change", sbsdlcyyCalc );
    $jQ("[name='sbsdlcm']").on( "change", sbsdlcyyCalc );
    $jQ("[name='sbsdlcy']").on( "change", sbsdlcyyCalc );
    sbsdlcyyCalc();
    $jQ("[name='sbcdpw']").on( "change", sbntpyCalc );
    $jQ("[name='sbcppd']").on( "change", sbntpyCalc );
    $jQ("[name='sbcdur']").on( "change", sbntpyCalc );
    sbntpyCalc();
    // Set up switch triggers.
    $jQ("form [switch]").on("change", switcher);
    // Deactivate all the switch regions. (Note: We could just leave them all
    // inactive in the original HTML, but if for some reason JavaScript isn't
    // available, we need this to degrade gracefully.)
    $jQ("form [switch]").each(function(){
      var sname = "[id^='" + this.name + "-switch']";
      switchoff(sname);
      sname = "[id^='" + this.name + "-nswitch']";
      switchoff(sname);
    });
    // Now turn on all the ones whose triggers are switched on.
    $jQ("form [switch]").each(function(){
      var sname = "[id^='" + this.name + "-switch']";
      if ($jQ(this).prop("checked") && $jQ(this).val() == "y") {
        switchon(sname);
      }
      sname = "[id^='" + this.name + "-nswitch']";
      if ($jQ(this).prop("checked") && $jQ(this).val() != "y") {
        switchon(sname);
      }
    });
  }

} );

