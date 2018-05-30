#!/bin/bash 

# Description: Step 1: Order VM - Prepares variables for next step for stage3 VM. 
# Version : 1.0
# Author : SE CD team (Anand Radhakrishnan)

assign_publish_attributes(){

if [ "$2" = "03" ]
then
if [ "$1" = "apollo" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/apollo/cd_apollo66_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/apollo_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with Apollo configurations"
    target_application_code="MCOM.UNIFIEDNAV.JBoss"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "seo" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/seo/cd_seo_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/seo_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with SEO configurations"
    target_application_code="MCOM.SEO"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "fcc_etl" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/fcc/cd_fcc_etl_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/fcc_etl_fenced.json"
    template_description="This template is created from a JBOSS environment with FCC ETL configurations"
    target_application_code="MCOM.ETL"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mchub_dev" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mchub/cd_mchub_dev"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mchub_jboss_dev_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCHUB DEV configurations"
    target_application_code="MST.D2CMCHUB"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mchub_qa" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mchub/cd_mchub_qa"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mchub_jboss_qa_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCHUB QA configurations"
    target_application_code="MST.D2CMCHUB"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "tibco" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/tibco/tibco_app_config" 
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/Tibco_fenced.json"
    template_description="This template is created from a Tibco environment configurations"
    target_application_code="MCOM.TibcoEms"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "tibco66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/tibco/tibco66_app_config" 
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/Tibco_fenced_rhel66.json"
    template_description="This template is created from a Tibco environment configurations"
    target_application_code="MCOM.TibcoEms"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/cd_navapp_jboss_ews_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_mcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/cd_navapp_jboss_ews66_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/cd_navapp_jboss_ews_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_bcom_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_bcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/cd_navapp_jboss_ews66_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "wssg" ]
then
    JSON_TEMPLATE_CONFIG="qa/cd_wssg_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/wssg_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="wssg"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "wssg66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/wssg/pd_wssg_eap_config66"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/wssg_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sns" ]
then
    JSON_TEMPLATE_CONFIG="qa/cd_sns_eap_ews_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/sns_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.SearchSend.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sns66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sns/cd_sns_eap_ews_config66"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/sns_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.SearchSend.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "msp_customer" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcustomer_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_customer66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer66_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcustomer_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_content66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content66_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_content" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcontent_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "sdp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sdp/cd_sdp_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mcom_sdp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM SDP configurations"
    target_application_code="MCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sdp_mcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sdp/cd_sdp66_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mcom_sdp_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCOM SDP configurations"
    target_application_code="MCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sdp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/sdp/cd_sdp_jboss_config_bcom"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/bcom_sdp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with BCOM SDP configurations"
    target_application_code="BCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sdp_bcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/sdp/cd_sdp66_jboss_config_bcom"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/bcom_sdp_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with BCOM SDP configurations"
    target_application_code="BCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "msp_order" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_order66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order66_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "shopapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "shopapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_jboss_ews_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "shopapp_mcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews66_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "shopapp_bcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_bcom_jboss_ews66_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer_batch_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_order_batch" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.OrderB"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_order_batch66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.OrderB"
    customize_guest="true"
    customize_template="true"    
elif [ "$1" = "msp_discovery" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with Discovery configurations"
    target_application_code="MCOM.MSP.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "oes" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/oes/cd_oes_jboss_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/oes_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with OES configurations"
    target_application_code="MCOM.OES.JBOSS"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mobapp" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp_jboss_ews"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mobapp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with Mobapp configurations"
    target_application_code="MCOM.MOBILE.App"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mobapp66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp66_jboss_ews"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mobapp_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with Mobapp configurations"
    target_application_code="MCOM.MOBILE.App"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mobweb" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobweb/cd_mobweb_jboss_ews"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mobweb_fenced.json"
    template_description="This template is created from a JBOSS environment with Mobwqeb configurations"
    target_application_code="MCOM.MOBILE.Web"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mobweb66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobweb/cd_mobweb66_jboss_ews"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mobweb_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with Mobwqeb configurations"
    target_application_code="MCOM.MOBILE.Web"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "pros66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/PROS/cd_pros66_jboss"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/pros_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with PROS configurations"
    target_application_code="MCOM.PROS.MMM"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "portal" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel66.json"
    template_description="This template is created for Portal with JBOSS EAP 6.3.3 on RHEL6.6"
    target_application_code="MCOM.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
fi
elif [ "$2" = "02" ]
then
if [ "$1" = "apollo" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/apollo/cd_apollo66_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/apollo_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with Apollo configurations"
    target_application_code="MCOM.UNIFIEDNAV.JBoss"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "fcc_etl_lorain" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/fcc/cd_fcc_etl_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/fcc_etl_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with FCC ETL configurations"
    target_application_code="MCOM.ETL"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "seo" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/seo/cd_seo_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/seo_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with SEO configurations"
    target_application_code="MCOM.SEO"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_content" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcontent_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_content66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content66_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"

elif [ "$1" = "msp_customer" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcustomer_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_customer66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer66_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcustomer_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer_batch_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.CustomerB"
    customize_guest="true"
    customize_template="true"    
elif [ "$1" = "msp_order" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_order66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order66_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "msp_order_batch66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.OrderB"
    customize_guest="true"
    customize_template="true"       
elif [ "$1" = "shopapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations for Lorain"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "sdp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sdp/cd_sdp_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mcom_sdp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM SDP configurations"
    target_application_code="MCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sdp_mcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sdp/cd_sdp66_jboss_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mcom_sdp_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM SDP configurations"
    target_application_code="MCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sdp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/sdp/cd_sdp_jboss_config_bcom_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/bcom_sdp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM SDP configurations"
    target_application_code="BCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sdp_bcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/sdp/cd_sdp66_jboss_config_bcom_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/bcom_sdp_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM SDP configurations"
    target_application_code="BCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "shopapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_jboss_ews_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations for Lorain"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "shopapp_mcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews66_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "shopapp_bcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_bcom_jboss_ews66_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mobapp" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp_jboss_ews"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mobapp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with Mobapp configurations"
    target_application_code="MCOM.MOBILE.App"
    customize_guest="true"
    customize_template="true"
    elif [ "$1" = "navapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/cd_navapp_jboss_ews_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_bcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/cd_navapp_jboss_ews66_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/cd_navapp_jboss_ews_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "navapp_mcom66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/cd_navapp_jboss_ews66_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/navapp_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "wssg66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/wssg/pd_wssg_eap_config66_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/wssg_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.XWSSG"
    customize_guest="false"
    customize_template="false"    
elif [ "$1" = "sns" ]
then
    JSON_TEMPLATE_CONFIG="qa/cd_sns_eap_ews_config_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/sns_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.SearchSend.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "sns66" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sns/cd_sns_eap_ews_config66_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/sns_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.SearchSend.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "$1" = "msp_discovery" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with Discovery configurations"
    target_application_code="MCOM.MSP.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "mobapp66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp66_jboss_ews_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/mobapp_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with Mobapp configurations"
    target_application_code="MCOM.MOBILE.App"
    customize_guest="true"
    customize_template="true" 
elif [ "$1" = "pros66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/PROS/cd_pros66_jboss_lorain"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/pros_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with PROS configurations"
    target_application_code="MCOM.PROS.MMM"
    customize_guest="true"
    customize_template="true"    
elif [ "$1" = "tibco66" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/tibco/tibco66_app_config_lorain" 
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/Tibco_fenced_rhel66_lorain.json"
    template_description="This template is created from a Tibco environment configurations"
    target_application_code="MCOM.TibcoEms"
    customize_guest="true"
    customize_template="true"
elif [ "$1" = "portal" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap_config"
    json_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created for Portal with JBOSS EAP 6.3.3 on RHEL6.6"
    target_application_code="MCOM.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
fi
    #previously echo "Currently apps are not able to publish to Lorain - in progress"
    #previously exit 1
fi

echo "template_description=${template_description}" >> paramaterizedTrigger.properties
echo "JSON_TEMPLATE=${JSON_TEMPLATE_CONFIG}" >> paramaterizedTrigger.properties
echo "target_application_code=${target_application_code}" >> paramaterizedTrigger.properties
echo "target_channel_code=$2" >> paramaterizedTrigger.properties
echo "customize_guest=${customize_guest}" >> paramaterizedTrigger.properties
echo "customize_template=${customize_template}" >> paramaterizedTrigger.properties

}

application=$1
target=$2

assign_publish_attributes $application $target

echo " Assigned variables for next step...."