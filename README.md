# Visualizing Species Migration in Sublimated Matrix for MALDI-IMS
This is an archive for the R codes used to plot the heatmaps and line charts for the MALDI-TOF IMS results included in the publication listed below.

## Files

* heatmap.R contains the script for generating the heatmap
* lineplot.R contains the script for generating the lineplots
* functions.R contains functions Ethan wrote for this project

## Reference Publication
Van Nuffel S, Elie N, **Yang E**, Nouet J, Touboul D, Chaurand P, Brunelle A. Insights into the MALDI Process after Matrix Deposition by Sublimation Using 3D ToF-SIMS Imaging. *Anal Chem. 2018 Feb 6;90(3):1907-1914*. [doi:10.1021/acs.analchem.7b03993](https://pubmed.ncbi.nlm.nih.gov/29295614/) PMID: 29295614.

## Contributors 

* Ethan Yang: Wrote 100% of the R codes for exporting and analyzing the IMS data currently available in this repository
* Pierre Chaurand: Provided guidance and outlined the data analysis pipeline; corrected figures

## Dependencies

* [MALDIquant](https://github.com/sgibb/MALDIquant) and [MALDIquantForeign](https://github.com/sgibb/MALDIquantForeign) for obtaining the peak intensities and reading the Bruker fid data
* [ggplot2](https://github.com/tidyverse/ggplot2) for producing the figures 

## Disclaimer
This repository contains only the scripts and functions for analyzing the imaging mass spectrometry data, not the SIMS-TOF data also included in the publication. The session info provided below were determined post publication and therefore may not be an accurate representation of the actual R enviornment during data analysis. The scripts provided only contains the necessary codes to produce the plots shown in the data and may need to be adapted for generic applications. It has also been scraped to remove any personal identifying information.

## License
Please reference the LICENSE document for details. 

## Session Info
R Studio: Version Unknown  
R version 3.4.4 (2018-03-15)  
Platform: x86_64-w64-mingw32/x64 (64-bit)  
Running under: Windows 10 x64 (build 18363)  

attached base packages:  

* stats
* graphics
* grDevices 
* utils
* datasets  
* methods   
* base     

other attached packages:
* MALDIquant_1.17 
* ggplot2_2.2.1  

loaded via a namespace (and not attached):
* Rcpp_0.12.16        
* BiocGenerics_0.24.0 
* MASS_7.3-49         
* munsell_0.4.3       
* colorspace_1.3-2    
* lattice_0.20-35     
* R6_2.2.2            
* rlang_0.2.0        
* plyr_1.8.4          
* tools_3.4.4         
* parallel_3.4.4      
* grid_3.4.4          
* Biobase_2.38.0      
* gtable_0.2.0        
* irlba_2.3.2         
* ProtGenerics_1.10.0
* lazyeval_0.2.1      
* yaml_2.1.19         
* mmand_1.5.3         
* tibble_1.4.2        
* Matrix_1.2-12       
* Cardinal_1.2.1      
* signal_0.7-6        
* sp_1.2-7           
* pillar_1.2.1        
* compiler_3.4.4      
* scales_0.5.0        
* XML_3.98-1.10       
* stats4_3.4.4       
