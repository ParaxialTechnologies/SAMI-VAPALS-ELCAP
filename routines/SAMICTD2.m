SAMICTD2 ;ven/gpl - ielcap: forms ;2018-03-07T18:48Z
 ;;18.0;SAMI;;
 ;
 ;
 quit  ; no entry from top
 ;
init2graph() ; initialize CTEVAL dictionary into graph cteval-dict
 n g,root
 s root=$$setroot^%wd("cteval-dict")
 k @root
 s g=$na(@root@("cteval-dict"))
 d INIT(g)
 q
 ;
INIT(g) ;
 ;
 ;# English Translation Dictionary for CT report generation
 ;# Last Updated: December 14, 2016
 ;#
 ;# - Phrasing shortened for updated CT Report used at Mount Sinai
 ;# - Breast Density Added
 ;# - Correction of nonsolid and noncalcified
 ;
 ;# Recommendations
 set @g@("repeatscreen")="Repeat screening"
 set @g@("annual")="Annual repeat CT"
 set @g@("followup")="Follow-up CT"
 set @g@("followupcontrast")="Follow-up CT with contrast"
 set @g@("bronchoscopy")="Bronchoscopy"
 set @g@("resection")="Resection"
 set @g@("biopsy")="CT-guided biopsy"
 set @g@("pet")="PET"
 set @g@("vat")="VAT"
 set @g@("ctfull")="Full diagnostic CT"
 set @g@("ctlimited")="Limited diagnostic CT"
 set @g@("ctbiopsy")="Full diagnostic CT and biopsy"
 set @g@("antibiotic")="Antibiotic treatment with a follow-up CT"
 set @g@("annualrepeat")="Annual repeat Diagnostic CT"
 ;
 ;# CT Type of Exam (cetex)
 set @g@("cetex","b")="Baseline"
 set @g@("cetex","a")="Annual repeat"
 set @g@("cetex","d")="Follow-up"
 ;
 ;# CT Protocol (cectp)
 set @g@("cectp","l")="low-dose CT"
 set @g@("cectp","m")="low-dose Dx CT / HRCT"
 set @g@("cectp","d")="standard Dx CT / HRCT"
 set @g@("cectp","i")="limited Dx CT / HRCT"
 ;
 ;# Is It New (Nodule x)? (cect[x]ch, x=1..10)
 set @g@("cectch","n")="is newly seen"
 set @g@("cectch","pn")="unchanged"
 set @g@("cectch","pd")="shows slight decrease"
 set @g@("cectch","pe")="shows marked decrease"
 set @g@("cectch","pi")="shows slight increase"
 set @g@("cectch","pj")="shows marked increase"
 set @g@("cectch","pw")="has resolved"
 set @g@("cectch","px")="is not a nodule"
 set @g@("cectch","pr")="has been resected"
 set @g@("cectch","pk")="previously seen but is not mentioned in outside report"
 set @g@("cectch","rn")="seen in retrospect with no change"
 set @g@("cectch","pv")="was not included in this scan"
 set @g@("cectch","po")="is obscured"
 set @g@("cectch","rd")="seen in retrospect with decrease"
 set @g@("cectch","ri")="seen in retrospect with slight increase"
 set @g@("cectch","rj")="seen in retrospect with marked increase"
 ;
 ;# Endoibronchial
 set @g@("cecten","tr")="trachea"
 set @g@("cecten","rm")="right main bronchus"
 set @g@("cecten","lm")="left main bronchus"
 set @g@("cecten","bi")="bronchus intermedius"
 set @g@("cecten","lul")="left upper lobe"
 set @g@("cecten","lll")="left lower lobe"
 set @g@("cecten","rul")="right upper lobe"
 set @g@("cecten","rml")="right middle lobe"
 set @g@("cecten","rll")="right lower lobe"
 ;
 ;# Likely Location (Nodule x) (cect[x]ll, x=1..10)
 set @g@("cectll","lul")="left upper lobe"
 set @g@("cectll","lll")="left lower lobe"
 set @g@("cectll","rul")="right upper lobe"
 set @g@("cectll","rml")="right middle lobe"
 set @g@("cectll","rll")="right lower lobe"
 ;
 ;# Nodule Texture (Nodule x) (cect[x]nt, x=1..10)
 set @g@("cectnt","s")="solid"
 set @g@("cectnt","m")="part-solid"
 set @g@("cectnt","g")="nonsolid"
 set @g@("cectnt","o")="unusual"
 ;
 ;# Smooth Edges (Nodule x) (cect[x]nt, x=1..10)
 set @g@("cectse","y")="smooth"
 set @g@("cectse","n")="irregularly marginated"
 set @g@("cectse","q")="ill-defined"
 ;
 ;# Calcifications (Nodule x) (cect[x]ca, x=1..10)
 set @g@("cectca","y")="calcified"
 set @g@("cectca","n")="noncalcified"
 set @g@("cectca","q")="possibly calcified"
 ;
 ;# Spiculations/Pleural Tags (Nodule x) (cect[x]sp, x=1..10)
 set @g@("cectsp","y")="spiculations / pleural tags are seen"
 set @g@("cectsp","n")="no spiculations or pleural tags are seen"
 ;
 ;# Pathologic Diagnosis (Nodule x) (cect[x]pd, x=1..10)
 set @g@("cectpd","aa")="AAH"
 set @g@("cectpd","ba")="BAC"
 set @g@("cectpd","ad")="Adenocarcinoma"
 set @g@("cectpd","as")="Adenosquamous"
 set @g@("cectpd","la")="Large cell"
 set @g@("cectpd","sq")="Squamous cell"
 set @g@("cectpd","sm")="Small cell"
 set @g@("cectpd","ct")="Carcinoid(typical)"
 set @g@("cectpd","ca")="Carcinoid(atypical)"
 set @g@("cectpd","be")="Benign"
 set @g@("cectpd","bs")="Benign specific"

 set @g@("cectac","f")="Follow-up CT"
 set @g@("cectac","a")="Antibiotic treatment with a follow-up CT"
 set @g@("cectac","e")="PET"
 set @g@("cectac","c")="Follow-up CT with contrast"
 set @g@("cectac","b")="CT-guided biopsy"
 set @g@("cectac","p")="Bronchoscopy"
 set @g@("cectac","v")="VAT"
 set @g@("cectac","r")="Resection"
 ;
 ;# The following is deprecated, but available for old forms
 set @g@("cectac","s")="repeat SCT"
 ;
 ;# Emphysema (ceem)
 set @g@("ceem","no")="None"
 set @g@("ceem","mi")="Minimal"
 set @g@("ceem","mo")="Moderate"
 set @g@("ceem","se")="Severe"
 ;
 ;# Bronchiectasis/Small Airway Disease (cebrs) [***IGNORE cebrs(n)]
 set @g@("cebrs","y")="Bronchiectasis/small airways disease"
 set @g@("cebrs","n")="No bronchiectasis or small airways disease"
 ;
 ;# Coronary Calcifications (cecclm, ceccld, cecccf, cdccrc)
 set @g@("cecc","no")="none"
 set @g@("cecc","mi")="minimal"
 set @g@("cecc","mo")="moderate"
 set @g@("cecc","ex")="extensive"
 ;
 set @g@("cebat","y")="Non-obstructive atelectasis seen in the"
 ;
 ;# Lymph Nodes (cemln, cemlnca)
 set @g@("cemln","y")="Lymph nodes are seen"
 set @g@("cemln","n")="No abnormal lymph nodes are seen"
 set @g@("cemlnca","c")="Lymph nodes are calcified."
 set @g@("cemlnca","n")="Lymph nodes are non-calcified."
 set @g@("cemlnca","b")="Lymph nodes are both calcified and non-calcified."
 ;
 ;# Hilar Abnormalities (ceha) [***IGNORE ceha(n)]
 set @g@("ceha","y")="Hilar Abnormalities:"
 set @g@("ceha","n")="No hilar abnormalities are seen"
 ;
 ;# Hilar Abnormalities - what(cehaw)
 set @g@("cehaw","hm")="hilar mass"
 ;
 ;# Hilar Abnormalities action (cehaa)
 set @g@("cehaa","f")=@g@("followup")
 set @g@("cehaa","c")=@g@("followupcontrast")
 set @g@("cehaa","b")=@g@("biopsy")
 set @g@("cehaa","p")=@g@("bronchoscopy")
 ;
 ;# Mediastinal Abnormalities (ceoma) [***IGNORE ceoma(n)]
 set @g@("ceoma","y")="Mediastinal Abnormalities:"
 set @g@("ceoma","n")="no mediastinal abnormalities are seen"
 ;
 ;# Mediastinal Abnormalities Action (ceomaa)[*** for ceomaa(o) use ceomas]
 set @g@("ceomaa","f")=@g@("followup")
 set @g@("ceomaa","c")=@g@("followupcontrast")
 set @g@("ceomaa","b")=@g@("biopsy")
 set @g@("ceomaa","p")=@g@("bronchoscopy")
 set @g@("ceomaa","e")=@g@("pet")
 set @g@("ceomaa","r")=@g@("resection")
 set @g@("ceomaa","v")=@g@("vat")
 set @g@("ceomaa","s")=@g@("repeatscreen")
 ;
 ;# Endobronchial Abnormalities (ceeba) [***IGNORE ceeba(n)]
 set @g@("ceeba","y")="Endobronchial Abnormalities: "
 set @g@("ceeba","n")="no endobroncial abnormalities are seen"
 ;
 ;# Endobronchial Abnormalities Action (ceebaa)
 set @g@("ceebaa","f")=@g@("followup")
 set @g@("ceebaa","p")=@g@("bronchoscopy")
 set @g@("ceebaa","b")=@g@("biopsy")
 set @g@("ceebaa","s")=@g@("repeatscreen")
 ;
 ;# Other clincially significant abnormalities location (ceafl)
 set @g@("ceafl","b")="breast"
 set @g@("ceafl","a")="abdomen"
 set @g@("ceafl","h")="head"
 set @g@("ceafl","n")="neck"
 ;
 ;# Consolidation (cefcp) [***IGNORE cefcp(n)]
 set @g@("cefcp","y")="consolidation is noted"
 set @g@("cefcp","n")="no consolidation is noted"
 ;
 ;# Consolidation What (cefcpw) [*** for cefcpw(os) use cefcps]
 set @g@("cefcpw","f")="Focal"
 set @g@("cefcpw","p")="Patchy"
 set @g@("cefcpw","d")="Diffuse"
 ;
 ;# Recommended Consolidation Action (cefcpa)[*** for cefcpa(o) use cefcpas]
 set @g@("cefcpa","s")=@g@("repeatscreen")
 set @g@("cefcpa","a")=@g@("antibiotic")
 set @g@("cefcpa","f")=@g@("followup")
 set @g@("cefcpa","b")=@g@("biopsy")
 set @g@("cefcpa","p")=@g@("bronchoscopy")
 ;
 ;# Pleural Effusion (cepel, ceper) [***IGNORE if both are no]
 set @g@("cepe","no")="no"
 set @g@("cepe","sm")="small"
 set @g@("cepe","mo")="moderate"
 set @g@("cepe","lg")="large"
 ;
 ;# Pericardial Effusion
 set @g@("ceprevm","mi")="minimal"
 set @g@("ceprevm","mo")="moderate"
 set @g@("ceprevm","ex")="marked"
 ;
 ;# Recommended Followup (cefu)
 set @g@("cefu","rs")=@g@("annual")
 set @g@("cefu","dx")=@g@("followup")
 set @g@("cefu","dl")=@g@("ctlimited")
 set @g@("cefu","af")=@g@("antibiotic")
 set @g@("cefu","fn")=@g@("biopsy")
 set @g@("cefu","cb")=@g@("ctbiopsy")
 set @g@("cefu","cc")=@g@("followupcontrast")
 set @g@("cefu","pe")=@g@("pet")
 set @g@("cefu","br")=@g@("bronchoscopy")
 set @g@("cefu","va")=@g@("vat")
 set @g@("cefu","su")=@g@("resection")
 set @g@("cefu","ad")=@g@("annualrepeat")
 ;
 ;# Recommended Follow-up (When) (cefuw)
 set @g@("cefuw","nw")="at this time"
 set @g@("cefuw","1m")="in one month"
 set @g@("cefuw","3m")="in three months"
 set @g@("cefuw","6m")="in six months"
 set @g@("cefuw","1y")="in one year"
 ;
 ;# Impression (Nodules) (ceimn)
 set @g@("ceimn","rs")="No evidence of nodules"
 set @g@("ceimn","ro")="Nodule(s) as described above. Consistent with old granulomatous disease"
 set @g@("ceimn","ru")="Nodule(s) unchanged, as described above"
 set @g@("ceimn","nf")="Nodule(s) as described above"
 ;
 ;# Impression (Other Findings) (ceimo)
 set @g@("ceimo","no")="No other abnormalities"
 set @g@("ceimo","oa")="Other abnormalities as described above"
 set @g@("ceimo","da")="Diffuse abnormalities"
 ;
 ;# Breast Density
 set @g@("ceobad","1")="almost entirely fatty"
 set @g@("ceobad","2")="scattered areas of fibroglandular density"
 set @g@("ceobad","3")="heterogeneously dense"
 set @g@("ceobad","4")="extremely dense"
 ;
 ;# LungRADS
 set @g@("celrad","0")="incomplete"
 set @g@("celrad","1")="negative"
 set @g@("celrad","2")="benign appearance or behavior"
 set @g@("celrad","3")="probably benign"
 set @g@("celrad","4A")="suspicious"
 set @g@("celrad","4B")="suspicious"
 set @g@("celrad","4X")="suspicious"
 ;
 ;# LungRADS also
 set @g@("celrc","0")="incomplete"
 set @g@("celrc","1")="negative"
 set @g@("celrc","2")="benign appearance or behavior"
 set @g@("celrc","3")="probably benign"
 set @g@("celrc","4A")="suspicious"
 set @g@("celrc","4B")="suspicious"
 set @g@("celrc","4X")="suspicious"
 ;
 ;# Impression Note:
 set @g@("note_imp")="Note: If LIMITED diagnostic scans are done to follow nodules, each one-year diagnostic scan which serves as the annual screening test MUST BE A FULL DIAGNOSTIC SCAN."
 ;
 ;# Study Complete Notice
 set @g@("study_complete")="You have completed the free screening provided by the New York Early Lung Cancer Action Program.  Further screening outside of this project is at the discretion of you and your physician.  Please call if you have any questions or concerns."
 ;
 ;#set CAC_recommendation "Since your Visual Coronary Artery Calcium Score (CAC), which is calculated by The Coordinating Site at Weill Medical College of Cornell University, is above 3, we recommend that you consult with a cardiologist, as you may be at risk for coronary artery disease."
 ;
 ;#set CAC_recommendation "Clinical interpretation of the Visual Coronary Artery Calcium Score (CAC) is provided in the attached writeup."
 ;
 ;#set CAC_recommendation "Since your Visual Coronary Artery Calcium Score (CAC) is above 3, we recommend that you consult with your physician for a clinical interpretation of this score, as you may be at risk for coronary artery disease."
 ;
 set @g@("CAC_recommendation")="Since your Visual CAC Score is above 3, we recommend that you consult with your physician for a clinical interpretation, as you may be at risk for coronary artery disease."
 q
 ;
