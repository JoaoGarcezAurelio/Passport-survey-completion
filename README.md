This contains the code for the Passport to Success trial's shiny dashboard regarding survey completion rates. This dashboard contains:

1 - Histogram with daily completion rates;
2 - Line graph with cumulative rates;
3 - Completion rate table;

Shiny app was built using:

R version 4.4.0 (2024-04-24)
Platform: aarch64-apple-darwin20
Running under: macOS Sonoma 14.5, RStudio 2024.4.1.748

Locale: en_US.UTF-8 / en_US.UTF-8 / en_US.UTF-8 / C / en_US.UTF-8 / en_US.UTF-8

Package version:
  archive_1.1.8       askpass_1.2.0      
  backports_1.4.1     base64enc_0.1.3    
  bigD_0.2.0          bit_4.0.5          
  bit64_4.0.5         bitops_1.0.7       
  blob_1.2.4          brio_1.1.5         
  broom_1.0.6         bsicons_0.1.2      
  bslib_0.7.0         cachem_1.1.0       
  callr_3.7.6         cellranger_1.1.0   
  cli_3.6.2           clipr_0.8.0        
  codetools_0.2-20    colorspace_2.1-0   
  commonmark_1.9.1    compiler_4.4.0     
  conflicted_1.2.0    cpp11_0.4.7        
  crayon_1.5.2        credentials_2.0.1  
  crosstalk_1.2.1     curl_5.2.1         
  cyclocomp_1.1.1     data.table_1.15.4  
  DBI_1.2.2           dbplyr_2.5.0       
  desc_1.4.3          digest_0.6.35      
  dplyr_1.1.4         DT_0.33            
  dtplyr_1.3.1        evaluate_0.23      
  fansi_1.0.6         farver_2.1.2       
  fastmap_1.2.0       fontawesome_0.5.2  
  forcats_1.0.0       fs_1.6.4           
  gargle_1.5.2        generics_0.1.3     
  gert_2.0.1          ggplot2_3.5.1      
  gh_1.4.1            gitcreds_0.1.2     
  glue_1.7.0          googledrive_2.1.1  
  googlesheets4_1.1.1 graphics_4.4.0     
  grDevices_4.4.0     grid_4.4.0         
  gt_0.10.1           gtable_0.3.5       
  gtExtras_0.5.0      haven_2.5.4        
  here_1.0.1          highr_0.10         
  hms_1.1.3           htmltools_0.5.8.1  
  htmlwidgets_1.6.4   httpuv_1.6.15      
  httr_1.4.7          httr2_1.0.1        
  ids_1.0.1           ini_0.3.1          
  isoband_0.2.7       jquerylib_0.1.4    
  jsonlite_1.8.8      juicyjuice_0.1.0   
  knitr_1.46          labeling_0.4.3     
  later_1.3.2         lattice_0.22-6     
  lazyeval_0.2.2      lifecycle_1.0.4    
  lintr_3.1.2         lubridate_1.9.3    
  magrittr_2.0.3      markdown_1.12      
  MASS_7.3.60.2       Matrix_1.7.0       
  memoise_2.0.1       methods_4.4.0      
  mgcv_1.9.1          mime_0.12          
  modelr_0.1.11       munsell_0.5.1      
  nlme_3.1.164        openssl_2.2.0      
  paletteer_1.6.0     parallel_4.4.0     
  pillar_1.9.0        pkgconfig_2.0.3    
  plotly_4.10.4       prettyunits_1.2.0  
  prismatic_1.1.2     processx_3.8.4     
  progress_1.2.3      promises_1.3.0     
  ps_1.7.6            purrr_1.0.2        
  R6_2.5.1            ragg_1.3.2         
  rappdirs_0.3.3      RColorBrewer_1.1.3 
  Rcpp_1.0.12         reactable_0.4.4    
  reactR_0.5.0        readr_2.1.5        
  readxl_1.4.3        rematch_2.0.0      
  rematch2_2.1.2      remotes_2.5.0      
  renv_1.0.7          reprex_2.1.0       
  rex_1.2.1           rlang_1.1.3        
  rmarkdown_2.27      rprojroot_2.0.4    
  rstudioapi_0.16.0   rvest_1.0.4        
  sass_0.4.9          scales_1.3.0       
  selectr_0.4.2       shiny_1.8.1.1      
  shinylive_0.1.1     shinythemes_1.2.0  
  sourcetools_0.1.7.1 splines_4.4.0      
  stats_4.4.0         stringi_1.8.4      
  stringr_1.5.1       sys_3.4.2          
  systemfonts_1.1.0   textshaping_0.3.7  
  thematic_0.1.5      tibble_3.2.1       
  tidyr_1.3.1         tidyselect_1.2.1   
  tidyverse_2.0.0     timechange_0.3.0   
  tinytex_0.51        tools_4.4.0        
  tzdb_0.4.0          usethis_2.2.3      
  utf8_1.2.4          utils_4.4.0        
  uuid_1.2.0          V8_4.4.2           
  vctrs_0.6.5         viridisLite_0.4.2  
  vroom_1.6.5         whisker_0.4.1      
  withr_3.0.0         xfun_0.44          
  xml2_1.3.6          xmlparsedata_1.0.5 
  xtable_1.8-4        yaml_2.3.8         
  zip_2.3.1    
