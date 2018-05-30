#!/bin/bash
#create new environment
date
TIME_S=`date +%s`

repo_name="cookbooks"
[[ -d "$repo_name" ]] && rm -rf $repo_name
git clone -b ${RELEASE} git@code.devops.fds.com:CD/${repo_name}.git

if [ -n "$1" ]
then
  ws_url=$1
else
  ws_url="http://mdc2vr4014:8080/jenkins/job/1.Order_VM/ws"
fi

if [ "${TARGET_CHANNEL}" = "03" ]
then
if [ "${APP}" = "apollo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/apollo/cd_apollo67_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/apollo_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Apollo configurations"
    target_application_code="MCOM.UNIFIEDNAV.JBoss"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_apollo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/apollo/cd_apollo67_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/apollo_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Apollo without JON configurations"
    target_application_code="MCOM.UNIFIEDNAV.WOJON.JBoss"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_apollo" ]
then
    JSON_TEMPLATE_CONFIG="apollo_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/apollo_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Apollo configurations"
    target_application_code="MCOM.UNIFIEDNAV.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_wojon_discovery" ]
then
    JSON_TEMPLATE_CONFIG="discovery_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP Discovery configurations"
    target_application_code="MCOM.MSP.WOJON.Discovery"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "seo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/SEO/cd_seo_jboss67"
    json_url="${ws_url}/cookbooks/jsons/compose/seo_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with SEO configurations"
    target_application_code="MCOM.SEO"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_seo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/SEO/cd_seo_jboss67"
    json_url="${ws_url}/cookbooks/jsons/compose/seo_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with SEO without JON configurations"
    target_application_code="MCOM.WOJON.SEO"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_seo" ]
then
    JSON_TEMPLATE_CONFIG="seo_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/seo_jboss_fenced_rhel67.json"
    template_description="This template is created for SEO with JBOSS without JON on RHEL6.7"
    target_application_code="MCOM.WOJON.SEO"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "fcc_etl67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/fcc/cd_fcc_etl_config"
    json_url="${ws_url}/cookbooks/jsons/compose/fcc_etl_rhel67_fenced.json"
    template_description="This template is created from a JBOSS environment with FCC ETL configurations"
    target_application_code="MCOM.ETL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_fcc_etl67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/fcc/cd_fcc_etl_config"
    json_url="${ws_url}/cookbooks/jsons/compose/fcc_etl_rhel67_fenced.json"
    template_description="This template is created from a JBOSS environment with FCC ETL without JON configurations"
    target_application_code="MCOM.WOJON.ETL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "mchub_dev" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mchub/cd_mchub_dev"
    json_url="${ws_url}/cookbooks/jsons/compose/mchub_jboss_dev_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCHUB DEV configurations"
    target_application_code="MST.D2CMCHUB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "mchub_qa" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mchub/cd_mchub_qa"
    json_url="${ws_url}/cookbooks/jsons/compose/mchub_jboss_qa_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MCHUB QA configurations"
    target_application_code="MST.D2CMCHUB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "tibco" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/tibco/tibco_app_config"
    json_url="${ws_url}/cookbooks/jsons/compose/Tibco_fenced.json"
    template_description="This template is created from a Tibco environment configurations"
    target_application_code="MCOM.TibcoEms"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "tibco67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/tibco/tibco67_app_config"
    json_url="${ws_url}/cookbooks/jsons/compose/Tibco_fenced_rhel67.json"
    template_description="This template is created from a Tibco environment configurations"
    target_application_code="MCOM.TibcoEms"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_mcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_navapp_mcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp without JON configurations"
    target_application_code="MCOM.WOJON.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/Navapp_QA_Bcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_bcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/Navapp_QA_Bcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_navapp_bcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/Navapp_QA_Bcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp without JON configurations"
    target_application_code="BCOM.WOJON.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_navapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="navapp_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Navapp configurations"
    target_application_code="MCOM.WOJON.NavApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_navapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="navapp_qa_bcom"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with BCOM Navapp configurations"
    target_application_code="BCOM.WOJON.NavApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wssg" ]
then
    JSON_TEMPLATE_CONFIG="qa/cd_wssg_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="wssg"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wssg67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/wssg/pd_wssg_eap_config67"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wojon_wssg67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/wssg/pd_wssg_eap_config67"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM without JON configurations"
    target_application_code="MCOM.WOJON.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wojon_un_wssg67" ]
then
    JSON_TEMPLATE_CONFIG="wojon_wssg_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM without JON configurations using unified cookbooks"
    target_application_code="MCOM.WOJON.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_wssg" ]
then
    JSON_TEMPLATE_CONFIG="wssg_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with WSSG configurations"
    target_application_code="MCOM.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_sns" ]
  then
      JSON_TEMPLATE_CONFIG="searchandsend_qa_mcom"
      json_url="${ws_url}/cookbooks/jsons/compose/sns_jboss_fenced_rhel67.json"
      template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
      target_application_code="ECOM.SearchSend.WOJON.JBoss"
      customize_guest="false"
      customize_template="false"
elif [ "${APP}" = "sns67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/sns/cd_sns_eap_ews_config67"
    json_url="${ws_url}/cookbooks/jsons/compose/sns_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.SearchSend.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wojon_sns67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/sns/cd_sns_eap_ews_config67"
    json_url="${ws_url}/cookbooks/jsons/compose/sns_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM without JON configurations"
    target_application_code="MCOM.SearchSend.WOJON.JBoss"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_customer" ]
then
    JSON_TEMPLATE_CONFIG="customer_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Customer"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="customer_batch_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer Batch without JON configurations"
    target_application_code="MCOM.MSP.WOJON.CustomerB"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_customer" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_customer67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer67_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_content67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content67_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_wojon_content" ]
then
    JSON_TEMPLATE_CONFIG="content_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.WOJON.Content"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wojon_msp_content67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content67_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPContent without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Content"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_content" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "sdp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sdp/cd_sdp_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/mcom_sdp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MCOM SDP configurations"
    target_application_code="MCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "sdp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/sdp/cd_sdp_jboss_config_bcom"
    json_url="${ws_url}/cookbooks/jsons/compose/bcom_sdp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with BCOM SDP configurations"
    target_application_code="BCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_order" ]
then
    JSON_TEMPLATE_CONFIG="order_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPOrder without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Order"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_order" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_order67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "shopapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews_config"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "shopapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_jboss_ews_config"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "shopapp_mcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_shopapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="shopapp_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp without JON configurations"
    target_application_code="MCOM.WOJON.ShopApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "shopapp_bcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_bcom_jboss_ews67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_shopapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="shopapp_qa_bcom"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp without JON configurations"
    target_application_code="BCOM.WOJON.ShopApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_wojon_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="customer_batch_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.WOJON.CustomerB"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer_batch_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_customer_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer67_batch_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_customer_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer67_batch_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch without JON configurations"
    target_application_code="MCOM.MSP.WOJON.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_wojon_order_batch" ]
then
    JSON_TEMPLATE_CONFIG="order_batch_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.WOJON.OrderB"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_order_batch" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.OrderB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_order_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.OrderB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_order_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch without JON configurations"
    target_application_code="MCOM.MSP.WOJON.OrderB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_discovery" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with Discovery configurations"
    target_application_code="MCOM.MSP.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_discovery67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Discovery configurations"
    target_application_code="MCOM.MSP.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_discovery67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Discovery without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "oes" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/oes/cd_oes_jboss_config"
    json_url="${ws_url}/cookbooks/jsons/compose/oes_jboss_fenced_rhel66.json"
    template_description="This template is created from a JBOSS environment with OES configurations"
    target_application_code="MCOM.OES.JBOSS"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_oes67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/oes/cd_oes_jboss_config_rhel67"
    json_url="${ws_url}/cookbooks/jsons/compose/oes_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with OES configurations"
    target_application_code="MCOM.WOJON.OES"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "mobapp" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp67_jboss_ews"
    json_url="${ws_url}/cookbooks/jsons/compose/mobapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Mobapp configurations"
    target_application_code="MCOM.MOBILE.App"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_mobapp" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp67_jboss_ews"
    json_url="${ws_url}/cookbooks/jsons/compose/mobapp_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Mobapp without JON configurations"
    target_application_code="MCOM.MOBILE.WOJON.App"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "mobweb" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobweb/cd_mobweb_jboss_ews"
    json_url="${ws_url}/cookbooks/jsons/compose/mobweb_fenced.json"
    template_description="This template is created from a JBOSS environment with Mobwqeb configurations"
    target_application_code="MCOM.MOBILE.Web"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_mobweb" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobweb/cd_mobweb67_jboss_ews"
    json_url="${ws_url}/cookbooks/jsons/compose/mobweb_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Mobwqeb without JON configurations"
    target_application_code="MCOM.MOBILE.WOJON.Web"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_pros" ]
then
    JSON_TEMPLATE_CONFIG="pros_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/pros_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with PROS configurations"
    target_application_code="MCOM.PROS.WOJON.MMM"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "pros67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/PROS/cd_pros67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/pros_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with PROS configurations"
    target_application_code="MCOM.PROS.MMM"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_portal" ]
then
    JSON_TEMPLATE_CONFIG="ecomportal_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel67.json"
    template_description="This template is created for Portal with JBOSS without JON on RHEL6.7"
    target_application_code="MCOM.NOJON.ECOMPORTAL"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "portal" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap_config"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel66.json"
    template_description="This template is created for Portal with JBOSS EAP 6.3.3 on RHEL6.6"
    target_application_code="MCOM.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "portal67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel67.json"
    template_description="This template is created for Portal with JBOSS on RHEL6.7"
    target_application_code="MCOM.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "nojon_portal67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap67_config"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel67.json"
    template_description="This template is created for Portal with JBOSS without JON on RHEL6.7"
    target_application_code="MCOM.NOJON.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_address" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/address/cd_msp_address_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspaddress_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP address configurations"
    target_application_code="ECOM.MSP.Address"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_address67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/address/cd_msp_address67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspaddress_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP address configurations"
    target_application_code="ECOM.MSP.Address"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_address67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/address/cd_msp_address67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/mspaddress_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP address without JON configurations"
    target_application_code="ECOM.MSP.WOJON.Address"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_tax" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/tax/cd_msp_tax67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msptax_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP tax configurations"
    target_application_code="ECOM.MSP.Tax"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_tax" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/tax/cd_msp_tax67_jboss"
    json_url="${ws_url}/cookbooks/jsons/compose/msptax_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP tax without JON configurations"
    target_application_code="ECOM.MSP.WOJON.Tax"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_tax" ]
then
    JSON_TEMPLATE_CONFIG="tax_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/msptax_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with MSP tax configurations"
    target_application_code="ECOM.MSP.WOJON.Tax"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "jdg" ]
then
  JSON_TEMPLATE_CONFIG="qa/ecom/jdg/cd_jdg_install"
    json_url="${ws_url}/cookbooks/jsons/compose/jdg_jboss_fenced.json"
    template_description="This template is created from a JBOSS environment with JDG configurations"
    target_application_code="ECOM.JDG"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "jdg67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/jdg/cd_jdg67_install"
    json_url="${ws_url}/cookbooks/jsons/compose/jdg_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with JDG without JON configurations"
    target_application_code="ECOM.WOJON.JDG"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "smartmonkey67" ]
then
  JSON_TEMPLATE_CONFIG="qa/ecom/smartmonkey/cd_smartmonkey_config"
    json_url="${ws_url}/cookbooks/jsons/compose/smartmonkey_jboss_fenced_rhel67.json"
    template_description="This template is created from a JBOSS environment with Smartmonkey configurations"
    target_application_code="ECOM.SMARTMONKEY"
    customize_guest="true"
    customize_template="true"
fi
elif [ "${TARGET_CHANNEL}" = "02" ]
then
if [ "${APP}" = "apollo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/apollo/cd_apollo67_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/apollo_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Apollo configurations"
    target_application_code="MCOM.UNIFIEDNAV.JBoss"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_apollo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/apollo/cd_apollo67_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/apollo_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Apollo without JON configurations"
    target_application_code="MCOM.UNIFIEDNAV.WOJON.JBoss"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_apollo" ]
then
    JSON_TEMPLATE_CONFIG="apollo_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/apollo_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Apollo configurations"
    target_application_code="MCOM.WOJON.UNIFIEDNAV"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_sns" ]
  then
      JSON_TEMPLATE_CONFIG="searchandsend_qa_mcom"
      json_url="${ws_url}/cookbooks/jsons/compose/sns_jboss_fenced_rhel67_lorain.json"
      template_description="This template is created from a JBOSS environment with MCOM or BCOM without jon configurations"
      target_application_code="ECOM.SearchSend.WOJON.JBoss"
      customize_guest="false"
      customize_template="false"
elif [ "${APP}" = "un_wojon_content" ]
then
    JSON_TEMPLATE_CONFIG="content_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.WOJON.Content"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_wojon_discovery" ]
then
    JSON_TEMPLATE_CONFIG="discovery_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSP Discovery configurations"
    target_application_code="MCOM.MSP.WONJON.Discovery"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "fcc_etl" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/fcc/cd_fcc_etl_config"
    json_url="${ws_url}/cookbooks/jsons/compose/fcc_etl_rhel67_fenced.json"
    template_description="This template is created from a JBOSS environment with FCC ETL configurations"
    target_application_code="MCOM.ETL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_fcc_etl67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/fcc/cd_fcc_etl_config"
    json_url="${ws_url}/cookbooks/jsons/compose/fcc_etl_rhel67_fenced.json"
    template_description="This template is created from a JBOSS environment with FCC ETL without JON configurations"
    target_application_code="MCOM.WOJON.ETL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_oes67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/oes/cd_oes_jboss_config_rhel67_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/oes_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with OES configurations"
    target_application_code="MCOM.WOJON.OES"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_seo" ]
then
    JSON_TEMPLATE_CONFIG="seo_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/seo_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created for SEO with JBOSS without JON on RHEL6.7"
    target_application_code="MCOM.WOJON.SEO"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "seo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/SEO/cd_seo_jboss67_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/seo_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with SEO configurations"
    target_application_code="MCOM.SEO"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_seo67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/SEO/cd_seo_jboss67_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/seo_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with SEO without JON configurations"
    target_application_code="MCOM.WOJON.SEO"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_content" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_content67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content67_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPContent configurations"
    target_application_code="MCOM.MSP.Content"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_content67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/content/cd_msp_content67_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcontent_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPContent without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Content"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_customer" ]
then
    JSON_TEMPLATE_CONFIG="customer_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Customer"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="customer_batch_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer Batch without JON configurations"
    target_application_code="MCOM.MSP.WOJON.CustomerB"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_customer" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_customer67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customer/cd_msp_customer67_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomer configurations"
    target_application_code="MCOM.MSP.Customer"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_customer_batch" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer_batch_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_customer_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer67_batch_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch configurations"
    target_application_code="MCOM.MSP.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_customer_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/customerbatch/cd_msp_customer67_batch_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspcustomer_batch_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPCustomerBatch without JON configurations"
    target_application_code="MCOM.MSP.WOJON.CustomerB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_order" ]
then
    JSON_TEMPLATE_CONFIG="order_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrder without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Order"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_order" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_order67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/order/cd_msp_order67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrder configurations"
    target_application_code="MCOM.MSP.Order"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_order_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel67._lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch configurations"
    target_application_code="MCOM.MSP.OrderB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_order_batch67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/orderbatch/cd_msp_order_batch67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/msporder_batch_jboss_fenced_rhel67._lorain.json"
    template_description="This template is created from a JBOSS environment with MSPOrderBatch without JON configurations"
    target_application_code="MCOM.MSP.WOJON.OrderB"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "shopapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations for Lorain"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "sdp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/sdp/cd_sdp_jboss_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mcom_sdp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM SDP configurations"
    target_application_code="MCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "sdp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/sdp/cd_sdp_jboss_config_bcom_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/bcom_sdp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM SDP configurations"
    target_application_code="BCOM.SDP"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "shopapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_jboss_ews_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations for Lorain"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "shopapp_mcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/shopapp/cd_shopapp_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp configurations"
    target_application_code="MCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_shopapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="shopapp_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with mcom shopapp without JON configurations"
    target_application_code="MCOM.WOJON.ShopApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "shopapp_bcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/shopapp/cd_shopapp_bcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp configurations"
    target_application_code="BCOM.ShopApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_shopapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="shopapp_qa_bcom"
    json_url="${ws_url}/cookbooks/jsons/compose/shopapp_bcom_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with bcom shopapp without JON configurations"
    target_application_code="BCOM.WOJON.ShopApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "mobapp" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp67_jboss_ews_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mobapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Mobapp configurations"
    target_application_code="MCOM.MOBILE.App"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_mobapp" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobapp/cd_mobapp67_jboss_ews_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mobapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Mobapp without JON configurations"
    target_application_code="MCOM.MOBILE.WOJON.App"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_mobweb" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/mobweb/cd_mobweb67_jboss_ews_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mobweb_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Mobweb without JON configurations"
    target_application_code="MCOM.MOBILE.WOJON.Web"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_navapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="navapp_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Navapp configurations"
    target_application_code="MCOM.WOJON.NavApp"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_navapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="navapp_qa_bcom"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM Navapp configurations"
    target_application_code="BCOM.WOJON.NavApp"
    customize_guest="false"
    customize_template="false"
    elif [ "${APP}" = "navapp_bcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/Navapp_QA_Bcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_bcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp configurations"
    target_application_code="BCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_navapp_bcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/bcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_bcom_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with BCOM NavApp without JON configurations"
    target_application_code="BCOM.WOJON.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_mcom" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "navapp_mcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp configurations"
    target_application_code="MCOM.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_navapp_mcom67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/Navapp/Navapp_QA_Mcom_jboss_ews67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/navapp_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM NavApp without JON configurations"
    target_application_code="MCOM.WOJON.NavApp"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wssg67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/wssg/pd_wssg_eap_config67_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM configurations"
    target_application_code="MCOM.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wojon_wssg67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/wssg/pd_wssg_eap_config67_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM without JON configurations"
    target_application_code="MCOM.WOJON.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "un_wssg" ]
then
    JSON_TEMPLATE_CONFIG="wssg_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with WSSG configurations"
    target_application_code="MCOM.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "wojon_un_wssg67" ]
then
    JSON_TEMPLATE_CONFIG="wojon_wssg_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/wssg_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MCOM or BCOM without JON configurations using unified cookbooks"
    target_application_code="MCOM.WOJON.XWSSG"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "msp_discovery" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created from a JBOSS environment with Discovery configurations"
    target_application_code="MCOM.MSP.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_discovery67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Discovery configurations"
    target_application_code="MCOM.MSP.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_discovery67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/discovery/cd_msp_discovery67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspdiscovery_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with Discovery without JON configurations"
    target_application_code="MCOM.MSP.WOJON.Discovery"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "tibco67" ]
then
    JSON_TEMPLATE_CONFIG="qa/ecom/tibco/tibco67_app_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/Tibco_fenced_rhel67_lorain.json"
    template_description="This template is created from a Tibco environment configurations"
    target_application_code="MCOM.TibcoEms"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_portal" ]
then
    JSON_TEMPLATE_CONFIG="ecomportal_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created for Portal with JBOSS without JON on RHEL6.7"
    target_application_code="MCOM.NOJON.ECOMPORTAL"
    customize_guest="false"
    customize_template="false"
elif [ "${APP}" = "portal" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel66_lorain.json"
    template_description="This template is created for Portal with JBOSS EAP 6.3.3 on RHEL6.6"
    target_application_code="MCOM.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "nojon_portal67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/ecomportal/cd_ecomportal_eap67_config_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/ecomportal_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created for Portal with JBOSS without JON on RHEL6.7"
    target_application_code="MCOM.NOJON.ECOMPORTAL"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_address" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/address/cd_msp_address_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspaddress_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSP address configurations"
    target_application_code="ECOM.MSP.Address"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_address67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/address/cd_msp_address67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspaddress_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSP address configurations"
    target_application_code="ECOM.MSP.Address"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "wojon_msp_address67" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/address/cd_msp_address67_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/mspaddress_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSP address without JON configurations"
    target_application_code="ECOM.MSP.WOJON.Address"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "msp_tax" ]
then
    JSON_TEMPLATE_CONFIG="qa/mcom/modularServices/tax/cd_msp_tax_jboss_lorain"
    json_url="${ws_url}/cookbooks/jsons/compose/msptax_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSP tax configurations"
    target_application_code="ECOM.MSP.Tax"
    customize_guest="true"
    customize_template="true"
elif [ "${APP}" = "un_tax" ]
then
    JSON_TEMPLATE_CONFIG="tax_qa_mcom"
    json_url="${ws_url}/cookbooks/jsons/compose/msptax_jboss_fenced_rhel67_lorain.json"
    template_description="This template is created from a JBOSS environment with MSP tax configurations"
    target_application_code="ECOM.MSP.WOJON.Tax"
    customize_guest="false"
    customize_template="false"
fi
    #previously echo "Currently apps are not able to publish to Lorain - in progress"
    #previously exit 1
fi


time_out="7200"

echo "PROFILE is $PROFILE"
echo "json_url is $json_url"
echo "time_out is $time_out"

echo "compose an environmentVM"
vmstr=`lc-mst-compose-env -p ${PROFILE} -u ${json_url} -t "${time_out}"`

#vmstr="vapp-9af349f9-92e8-4eee-9ab2-30e386c1eb99	ChefSolo_SEUSERS_1	11.120.64.14	Running"
if [ $? -ne 0 ]; then
    echo "environment allocation failed!"
    echo "vmstr: $vmstr"
    exit 1
fi

vm=($vmstr)
vm0="${vm[0]}"
vm1="${vm[1]}"

echo "vAppId   =>$vm0"
echo "VAppName =>$vm1"

# Just remove leading whitespace
#turn it on
shopt -s extglob
foo="${vmstr#$vm0}"

foo="${foo%"Running"}"

foo="${foo##*( )}"
foo="${foo##+([[:space:]])}"

foo="${foo#$vm1}"
foo="${foo##+([[:space:]])}"

# turn it off
shopt -u extglob

ips=($foo)

for j in "${ips[@]}"
do
echo "ip address: ${j%";"}"
echo "IP=${j}" >> paramaterizedTrigger.properties
done

echo "ip_list=$foo" >> paramaterizedTrigger.properties
echo "vappid=$vm0" >> paramaterizedTrigger.properties
echo "source_vapp_name=$vm1" >> paramaterizedTrigger.properties
echo "COOKBOOKS_URL=${COOKBOOKS_URL}" >> paramaterizedTrigger.properties
echo "template_name=${TEMPLATE_NAME}" >> paramaterizedTrigger.properties
echo "template_description=${template_description}" >> paramaterizedTrigger.properties
echo "JSON_TEMPLATE=${JSON_TEMPLATE_CONFIG}" >> paramaterizedTrigger.properties
echo "target_application_code=${target_application_code}" >> paramaterizedTrigger.properties
echo "target_channel_code=${TARGET_CHANNEL}" >> paramaterizedTrigger.properties
echo "customize_guest=${customize_guest}" >> paramaterizedTrigger.properties
echo "customize_template=${customize_template}" >> paramaterizedTrigger.properties
echo "RELEASE=${RELEASE}" >> paramaterizedTrigger.properties
echo "PROFILE=${PROFILE}" >> paramaterizedTrigger.properties
echo "APP=${APP}" >> paramaterizedTrigger.properties


echo "Sleeping for 60 seconds to wait for VM to fully boot."
sleep 60

date

TIME_E=`date +%s`
TIME_T=$((TIME_E-TIME_S))
TIME_MINUTES=$((TIME_T/60))
TIME_SECONDS=$((TIME_T%60))
echo "Total time is ${TIME_MINUTES} minutes and ${TIME_SECONDS} seconds"
