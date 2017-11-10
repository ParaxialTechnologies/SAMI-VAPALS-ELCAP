package com.paraxialtech.vapals;

import com.google.common.collect.ImmutableList;
import org.apache.commons.lang3.tuple.ImmutableTriple;
import org.apache.commons.lang3.tuple.Triple;

import java.util.List;

public class BackgroundConstants {

    //TODO: Generate this list using the CSV /docs/elements/dd/background-dd-map.csv.
    public static final List<Triple<String, String, String>> FIELDS = new ImmutableList.Builder<Triple<String, String, String>>()
            .add(new ImmutableTriple<>("sbdob", "DATE OF BIRTH", "03/15/1980"))
            .add(new ImmutableTriple<>("sbage", "AGE", "37"))
            .add(new ImmutableTriple<>("sb???", "NAME", "Willy Wonka"))
            .add(new ImmutableTriple<>("sbdop", "INTAKE DATE", "11/10/2017"))
            .add(new ImmutableTriple<>("sbocc", "OCCUPATION", "Software Developer"))
            .add(new ImmutableTriple<>("sboccc", "OCCUPATION CODE", "3"))
            .add(new ImmutableTriple<>("sbsex", "SEX", "M"))
            .add(new ImmutableTriple<>("sbph", "HEIGHT", "70.5"))
            .add(new ImmutableTriple<>("sbphu", "HEIGHT UNITS", "i"))
            .add(new ImmutableTriple<>("sbpw", "WEIGHT", "205"))
            .add(new ImmutableTriple<>("sbpwu", "WEIGHT UNITS", "p"))
            .add(new ImmutableTriple<>("sbbmi", "BMI", "36.1234"))
            .add(new ImmutableTriple<>("sbet", "ETHNICITY", "n")) //hispanic y/n
            .add(new ImmutableTriple<>("sbrc", "RACE", "o")) //other
            .add(new ImmutableTriple<>("sbrcs", "RACE (SPECIFY)", "purple"))
            .add(new ImmutableTriple<>("sbed", "LEVEL OF EDUCATION", "bd")) //4y degree
            .add(new ImmutableTriple<>("sbmly", "MILITARY", "y"))
            .add(new ImmutableTriple<>("sbmlyo", "BRANCH", "army"))
            .add(new ImmutableTriple<>("sbmeq", "SCAN ORDERED", "y"))
            .add(new ImmutableTriple<>("???", "PRACTITIONER NAME", "Dr. Darth Vader"))
            .add(new ImmutableTriple<>("sbopnpi", "PRACTITIONER NPI", "ABC123"))
            .add(new ImmutableTriple<>("sbdsd", "SHARED DECISION", "y"))
            .add(new ImmutableTriple<>("sboppy", "PRACTITIONER PACK YEARS", "20"))
            .add(new ImmutableTriple<>("sbopss", "PRACTITIONER SMOKING STATUS", "c")) //current
            .add(new ImmutableTriple<>("sbopqy", "PRACTITIONER QUIT YEARS", "0"))
            .add(new ImmutableTriple<>("sboas", "PRACTITIONER ASYMPTOMATIC", "y"))
            .add(new ImmutableTriple<>("sbopci", "CLINICAL INFORMATION", "Test\n")) // this looks like a multi-line field: CLINICAL INFORMATION:\n 1>
            .add(new ImmutableTriple<>("sbfc", "FAMILY HISTORY OF LUNG CANCER", "y"))
            .add(new ImmutableTriple<>("sbfcm", "LUNG CANCER FATHER", "y"))
            .add(new ImmutableTriple<>("sbfcf", "LUNG CANCER MOTHER", "y"))
            .add(new ImmutableTriple<>("sbfcs", "LUNG CANCER SIBLING", "n"))
            .add(new ImmutableTriple<>("sbhco", "ALL OTHER CANCERS", "y"))
            .add(new ImmutableTriple<>("sbhcdod", "OTHER CANCERS WHEN", "01/01/2000"))
            .add(new ImmutableTriple<>("snhcpbo", "OTHER CANCERS SITE", "Wisconsin"))
            .add(new ImmutableTriple<>("smbpa", "ASTHMA", "y"))
            .add(new ImmutableTriple<>("sbmpat", "ASTHMA TREATED", "y"))
            .add(new ImmutableTriple<>("sbmpc", "EMPHYSEMA OR COPD", "y"))
            .add(new ImmutableTriple<>("sbmpc", "EMPHYSEMA OR COPD WHEN", "01/01/2001"))
            .add(new ImmutableTriple<>("sbmpht", "HYPERTENSION", "y"))
            .add(new ImmutableTriple<>("sbmphtt", "HYPERTENSION TREATED", "y"))
            .add(new ImmutableTriple<>("sbmphtsw", "HYPERTENSION SINCE", "1/1/2002"))
            .add(new ImmutableTriple<>("sbmphthv", "HYPERTENSION HIGHEST VALUE", "no recall"))
            .add(new ImmutableTriple<>("sbmphc", "HIGH CHOLESTEROL", "y"))
            .add(new ImmutableTriple<>("sbmpct", "HIGH CHOLESTEROL TREATED", "y"))
            .add(new ImmutableTriple<>("sbmpas", "ANGIOPLASTY OR STENT", "y"))
            .add(new ImmutableTriple<>("sbmpasw", "ANGIOPLASTY WHEN", "2/1/2003"))
            .add(new ImmutableTriple<>("sbmpast", "ANGIOPLASTY WHERE", "New York"))
            .add(new ImmutableTriple<>("sbmpmi", "MI", "?"))
            .add(new ImmutableTriple<>("sbmpmid", "MI WHEN", "3/1/2003"))
            .add(new ImmutableTriple<>("sbmpmiw", "MI WHERE", "over there"))
            .add(new ImmutableTriple<>("sbmps", "STROKE", "n"))
            .add(new ImmutableTriple<>("sbmpsd", "STROKE WHEN", "4/1/2004"))
            .add(new ImmutableTriple<>("sbmpsw", "STROKE WHERE", "not applicable"))
            .add(new ImmutableTriple<>("sbmppv", "PERIPHERAL VASCULAR DISEASE", "y"))
            .add(new ImmutableTriple<>("sbmpd", "DIABETES", "y"))
            .add(new ImmutableTriple<>("sbmpdw", "DIABETES AGE", "12"))
            .add(new ImmutableTriple<>("sbmpdt", "DIABETES TREATED", "y"))
            .add(new ImmutableTriple<>("sbmpld", "LIVER DISEASE", "y"))
            .add(new ImmutableTriple<>("sbmplds", "LIVER SEVERITY", "s")) //severe
            .add(new ImmutableTriple<>("sbmprd", "RENAL DISEASE", "y"))
            .add(new ImmutableTriple<>("sbmprds", "RENAL SEVERITY", "m"))
            .add(new ImmutableTriple<>("sbwc", "LUNG CANCER SYMPTOMS", "y"))
            .add(new ImmutableTriple<>("sbwcos", "SYMPTOMS OTHER SPECIFY", "told me"))
            .add(new ImmutableTriple<>("sbact", "CHEST CT WHEN", "b")) //6-18m ago
            .add(new ImmutableTriple<>("sbahcl", "CHEST CT WHERE", "3rd floor"))
            .add(new ImmutableTriple<>("sbahpft", "PULMONARY FUNCTION TEST", "y"))
            .add(new ImmutableTriple<>("sbfev1", "FEV1 (L/s)", "3.14"))
            .add(new ImmutableTriple<>("sbfvc", "FVC (L)", "6.28"))
            .add(new ImmutableTriple<>("sbffr", "FEV1/FVC (%)", "30.11"))
            .add(new ImmutableTriple<>("sbcop", "DIFFUSION CAPACITY", "4.1222"))
            .add(new ImmutableTriple<>("sbaha", "ASBESTOS EXPOSURE", "y"))
            .add(new ImmutableTriple<>("???", "Select ASBESTOS OCCUPATION", "j\n\n")) //auto repair TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("sbahaoo", "ASBESTOS OTHER SPECIFY", "demolition"))
            .add(new ImmutableTriple<>("???", "SMOKER", "y")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "SECONDHAND", "y")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("sbsas", "SMOKING AGE", "15"))
            .add(new ImmutableTriple<>("sbshsa", "SMOKED IN PAST MONTH", "y"))
            .add(new ImmutableTriple<>("sbsdlcd", "FORMER DAYS PER WEEK", "y"))
            .add(new ImmutableTriple<>("???", "LAST CIGARETTE DATE", "11/9/17")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "QUIT YEARS", "0")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "FORMER DAYS PER WEEK", "7")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("sbfppd", "FORMER PPD", "3"))
            .add(new ImmutableTriple<>("sbfdur", "FORMER DURATION", "23.51"))
            .add(new ImmutableTriple<>("sbcdpw", "CURRENT DAYS PER WEEK", "7"))
            .add(new ImmutableTriple<>("sbcppd", "CURRENT PPD", "4"))
            .add(new ImmutableTriple<>("sbcdur", "CURRENT DURATION", "17.12"))
            .add(new ImmutableTriple<>("sbntpy", "TOTAL PACK YEARS", "40"))
            .add(new ImmutableTriple<>("sbqttq", "TRIED TO QUIT", "y"))
            .add(new ImmutableTriple<>("sbqttqtb", "TRIED HOW MANY TIMES", "2"))
            .add(new ImmutableTriple<>("sbqly2", "QUIT PAST 12 MONTHS", "a"))
            .add(new ImmutableTriple<>("sbqst", "THINKING OF QUITTING", "n"))
            .add(new ImmutableTriple<>("sbcpd", "CESSATION PACKET", "y"))
            .add(new ImmutableTriple<>("???", "SECONDHAND WORKSITE", "y")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "SECONDHAND WORK EXPOSURE", "y")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "Select AGE RANGE", "14-18")) //when asked again need to hit <enter> //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "  JOB", "demo man")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "  SMOKING", "y")) //TODO: need code id from data dictionary
            .add(new ImmutableTriple<>("???", "SECONDHAND HOME UNDER 18", "y"))
            .add(new ImmutableTriple<>("sbhsyh", "SMOKING ALLOWED HOME", "y"))
            .add(new ImmutableTriple<>("sbmsy", "MOTHER SMOKE UNDER 7", "y"))
            .add(new ImmutableTriple<>("sbmst", "MOTHER SMOKE 7-18", "y"))
            .add(new ImmutableTriple<>("sbosy", "HOME CHILDHOOD OTHER", "y"))
            .add(new ImmutableTriple<>("sbslws", "SECONDHAND CURRENT", "y"))
            .add(new ImmutableTriple<>("sbhso", "SECONDHAND HOME ADULT", "n"))
            .add(new ImmutableTriple<>("sbsfb1", "GENERAL HEALTH", "2"))
            .add(new ImmutableTriple<>("sbsfb2", "HEALTH ACTIVITY LIMITS", "2"))
            .add(new ImmutableTriple<>("sbsfb3", "HEALTH DAILY WORK", "2"))
            .add(new ImmutableTriple<>("sbsfb4", "BODILY PAIN", "1"))
            .add(new ImmutableTriple<>("sbsfb5", "ENERGY", "3"))
            .add(new ImmutableTriple<>("sbsfb6", "HEALTH SOCIAL LIMITS", "5"))
            .add(new ImmutableTriple<>("sbsfb7", "HEALTH EMOTIONAL", "2"))
            .add(new ImmutableTriple<>("sbsfb8", "HEALTH DAILY ACTIVITIES", "1"))
            .add(new ImmutableTriple<>("sbcfs", "CONSENT SIGNED", "y"))
            .add(new ImmutableTriple<>("sbdoc", "CONSENT DATE", "11/11/2017"))
            .add(new ImmutableTriple<>("sbioc", "CONSENT OBTAINED BY", "me myself and i"))
            .build();
}
