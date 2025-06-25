CREATE OR REPLACE PACKAGE WMX_SPED_RESSARC_RJ_REL IS
/*
  BuscaNumItem
*/
FUNCTION BuscaNumItem(pDISCRI_ITEM in VARCHAR2) RETURN Integer;
/*BuscaParam
*/
Function BuscaParam (  pCOD_EMPRESA    IN VARCHAR2
                       ,pCOD_ESTAB      IN VARCHAR2
                       ,pGRUPO_PRODUTO  IN VARCHAR2
                       ,pIND_PRODUTO    IN VARCHAR2
                       ,pCOD_PRODUTO    IN VARCHAR2
                       ,pCOD_NBM        IN VARCHAR2
                       ,pDATA_EMISSAO   IN DATE
                       ,pIndCampo       IN VARCHAR2 )  Return NUMBER;

CURSOR C_REL_MEDIA_POND Is
Select media_pond.*
From WMX_ST_RJ_MEDIA_POND media_pond
WHERE  media_pond.COD_EMPRESA     = Pkg_Dados_Param.getCodEmpresa
AND    media_pond.COD_ESTAB       = Pkg_Dados_Param.getCodEstab
AND    media_pond.DATA            BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim
Order By media_pond.COD_EMPRESA asc,
         media_pond.COD_ESTAB asc,
         media_pond.DATA asc,
         media_pond.IND_PRODUTO asc,
         media_pond.COD_PRODUTO asc
;

CURSOR C_REL_C181_NF_DEV_SAI Is
Select
    nf_sai.COD_EMPRESA,
    nf_sai.COD_ESTAB,
    nf_sai.DATA_FISCAL,
    nf_sai.MOVTO_E_S,
    nf_sai.NORM_DEV,
    x2005.COD_DOCTO,
    nf_sai.IDENT_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_sai.IDENT_FIS_JUR,
    nf_sai.NUM_DOCFIS,
    nf_sai.SERIE_DOCFIS,
    nf_sai.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) as NUM_ITEM,
    nf_sai.NUM_DOCFIS_REF,
    nf_sai.SERIE_DOCFIS_REF,
    nf_sai.SUB_SERIE_DOCFIS_REF,
    x2005a.COD_DOCTO as COD_DOCTO_REF,
    nf_sai.IDENT_DOCTO_REF,
    nf_sai.DATA_FISCAL_REF,
    nf_sai.NUM_ITEM_DOC_REF,
    nf_sai.COD_MOTIVO,
    nf_sai.QTD_CONV,
    x2007.COD_MEDIDA,
    nf_sai.VLR_UNIT_CONV,
    nf_sai.VLR_ICMS_CONV,
    nf_sai.VLR_UNIT_ICMS_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_ESTQ_SAI,
    nf_sai.VLR_UNIT_FCP_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMS_OPER_SAI,
    nf_sai.VLR_UNIT_ICMSS_REST_SAI,
    nf_sai.VLR_UNIT_FCP_REST_SAI,
    nf_sai.VLR_UNIT_ICMSS_COMPL_SAI,
    nf_sai.VLR_UNIT_FCP_COMPL_SAI,
    x2013.ind_produto as IND_PROD_NF_DEV,
    x2013.cod_produto as COD_PROD_NF_DEV
From x308_info_compl_st_it_merc_dev nf_sai,
     X2005_TIPO_DOCTO     x2005,
     X2005_TIPO_DOCTO     x2005a,
     X2013_PRODUTO        x2013,
     X04_PESSOA_FIS_JUR   x04,
     X2007_MEDIDA         x2007
WHERE  nf_sai.COD_EMPRESA     = Pkg_Dados_Param.getCodEmpresa
AND    nf_sai.COD_ESTAB       = Pkg_Dados_Param.getCodEstab
AND    nf_sai.DATA_FISCAL     BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim

AND    nf_sai.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_sai.ident_docto_ref = x2005a.ident_docto

AND    nf_sai.IDENT_FIS_JUR = X04.IDENT_FIS_JUR
AND    nf_sai.IDENT_MEDIDA = X2007.IDENT_MEDIDA (+)
AND    TO_NUMBER(SUBSTR(nf_sai.DISCRI_ITEM,1,12)) = X2013.IDENT_PRODUTO
AND    nf_sai.Cod_Motivo IN ('RJ500', 'RJ600', 'RJ800')

Order By nf_sai.COD_EMPRESA asc,
         nf_sai.COD_ESTAB asc,
         nf_sai.DATA_FISCAL asc,
         nf_sai.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) asc
;

CURSOR C_REL_C186_NF_DEV_ENT Is
Select
    nf_ent.COD_EMPRESA,
    nf_ent.COD_ESTAB,
    nf_ent.DATA_FISCAL,
    nf_ent.MOVTO_E_S,
    nf_ent.NORM_DEV,
    x2005.COD_DOCTO,
    nf_ent.IDENT_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_ent.IDENT_FIS_JUR,
    nf_ent.NUM_DOCFIS,
    nf_ent.SERIE_DOCFIS,
    nf_ent.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_ent.DISCRI_ITEM) as NUM_ITEM,
    nf_ent.NUM_DOCFIS_REF,
    nf_ent.SERIE_DOCFIS_REF,
    nf_ent.SUB_SERIE_DOCFIS_REF,
    x2005a.COD_DOCTO as COD_DOCTO_REF,
    nf_ent.IDENT_DOCTO_REF,
    nf_ent.DATA_FISCAL_REF,
    nf_ent.NUM_ITEM_DOC_REF,
    nf_ent.COD_MOTIVO,
    nf_ent.QTD_CONV,
    x2007.COD_MEDIDA,
    nf_ent.VLR_UNIT_CONV,
    nf_ent.VLR_ICMS_CONV,
    nf_ent.vlr_unit_bc_icmss_ent,
    nf_ent.vlr_unit_icmss_conv_ent,
    nf_ent.vlr_unit_fcp_conv_ent,
    x2013.ind_produto as IND_PROD_NF_DEV,
    x2013.cod_produto as COD_PROD_NF_DEV
From x308_info_compl_st_it_merc_dev nf_ent,
     X2005_TIPO_DOCTO     x2005,
     X2005_TIPO_DOCTO     x2005a,
     X2013_PRODUTO        x2013,
     X04_PESSOA_FIS_JUR   x04,
     X2007_MEDIDA         x2007
WHERE  nf_ent.COD_EMPRESA     = Pkg_Dados_Param.getCodEmpresa
AND    nf_ent.COD_ESTAB       = Pkg_Dados_Param.getCodEstab
AND    nf_ent.DATA_FISCAL     BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim

AND    nf_ent.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_ent.ident_docto_ref = x2005a.ident_docto

AND    nf_ent.IDENT_FIS_JUR = X04.IDENT_FIS_JUR
AND    nf_ent.IDENT_MEDIDA = X2007.IDENT_MEDIDA(+)
AND    TO_NUMBER(SUBSTR(nf_ent.DISCRI_ITEM,1,12)) = X2013.IDENT_PRODUTO
AND    nf_ent.Cod_Motivo IN ('RJ400')

Order By nf_ent.COD_EMPRESA asc,
         nf_ent.COD_ESTAB asc,
         nf_ent.DATA_FISCAL asc,
         nf_ent.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_ent.DISCRI_ITEM) asc
;

CURSOR C_REL_C185  Is
SELECT
    nf_sai.COD_EMPRESA,
    nf_sai.COD_ESTAB,
    nf_sai.DATA_FISCAL,
    nf_sai.MOVTO_E_S,
    nf_sai.NORM_DEV,
    x2005.COD_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_sai.NUM_DOCFIS,
    nf_sai.SERIE_DOCFIS,
    nf_sai.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) as NUM_ITEM,
    nf_sai.QTD_CONV,
    (SELECT x2007_X296.COD_MEDIDA FROM X2007_MEDIDA x2007_X296 WHERE nf_sai.IDENT_MEDIDA = x2007_X296.IDENT_MEDIDA) as COD_MEDIDA,
    nf_sai.VLR_UNIT_CONV,
    nf_sai.VLR_ICMS_CONV,
    nf_sai.COD_MOTIVO_SAI,
    nf_sai.VLR_UNIT_ICMS_OPER_SAI,
    nf_sai.VLR_UNIT_ICMS_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_ESTQ_SAI,
    nf_sai.VLR_UNIT_FCP_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_REST_SAI,
    nf_sai.VLR_UNIT_FCP_REST_SAI,
    nf_sai.VLR_UNIT_ICMSS_COMPL_SAI,
    nf_sai.VLR_UNIT_FCP_COMPL_SAI,

    x2013.GRUPO_PRODUTO,
    x2013.IND_PRODUTO,
    x2013.COD_PRODUTO,
   (SELECT x2007_PROD.COD_MEDIDA FROM X2007_MEDIDA x2007_PROD WHERE X2013.IDENT_MEDIDA = x2007_PROD.IDENT_MEDIDA) as COD_MEDIDA_PROD,
    X2043.COD_NBM   as COD_NBM_PROD,
    x2013.COD_CEST  as COD_CEST_PROD,

    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'PRC_REDUCAO_BC')  as PRC_REDUCAO_BC,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_INTERNA')    as ALIQ_INTERNA,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_FCP')        as ALIQ_FCP,
    x08.Quantidade       as QTD_X08,
    x08.Quantidade_Conv  as QTD_CONV_X08,
   (SELECT x2007_X08.GRUPO_MEDIDA FROM X2007_MEDIDA x2007_X08 WHERE x08.IDENT_MEDIDA = x2007_X08.IDENT_MEDIDA) as GRUPO_MEDIDA_X08,
   (SELECT x2007_X08.COD_MEDIDA FROM X2007_MEDIDA x2007_X08 WHERE x08.IDENT_MEDIDA = x2007_X08.IDENT_MEDIDA) as COD_MEDIDA_X08,
    x08.Vlr_Contab_Item as VLR_CONTAB_X08

From X296_INFO_COMPL_ST_ITENS_MERC nf_sai,
     X08_ITENS_MERC     x08,
     X2005_TIPO_DOCTO   x2005,
     X2013_PRODUTO      x2013,
     X2043_COD_NBM      X2043,
     X04_PESSOA_FIS_JUR x04

WHERE  nf_sai.COD_EMPRESA   = Pkg_Dados_Param.getCodEmpresa
AND    nf_sai.COD_ESTAB     = Pkg_Dados_Param.getCodEstab
AND    nf_sai.DATA_FISCAL   BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim
AND    nf_sai.movto_e_s     = '9'

AND    nf_sai.COD_EMPRESA = x08.COD_EMPRESA
AND    nf_sai.COD_ESTAB = x08.COD_ESTAB
AND    nf_sai.DATA_FISCAL = x08.DATA_FISCAL
AND    nf_sai.MOVTO_E_S = x08.MOVTO_E_S
AND    nf_sai.NORM_DEV = x08.NORM_DEV
AND    nf_sai.IDENT_DOCTO = x08.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    nf_sai.NUM_DOCFIS = x08.NUM_DOCFIS
AND    nf_sai.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    nf_sai.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS
AND    nf_sai.discri_item = x08.discri_item

AND    nf_sai.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = X04.IDENT_FIS_JUR

AND    x08.ident_produto = x2013.ident_produto

AND    X2043.IDENT_NBM (+) = X2013.IDENT_NBM

Order By nf_sai.COD_EMPRESA asc,
         nf_sai.COD_ESTAB asc,
         nf_sai.DATA_FISCAL asc,
         nf_sai.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM)  asc
;

cursor c_mm_saidas is 
SELECT
    'C185' as registro,
    nf_sai.COD_EMPRESA,
    nf_sai.COD_ESTAB,
    nf_sai.DATA_FISCAL,
    nf_sai.MOVTO_E_S,
    nf_sai.NORM_DEV,
    x07.num_autentic_nfe as chv_nfe,
    x2005.COD_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_sai.NUM_DOCFIS,
    nf_sai.SERIE_DOCFIS,
    nf_sai.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) as NUM_ITEM,
    nf_sai.QTD_CONV,
    (SELECT x2007_X296.COD_MEDIDA FROM X2007_MEDIDA x2007_X296 WHERE nf_sai.IDENT_MEDIDA = x2007_X296.IDENT_MEDIDA) as COD_MEDIDA,
    nf_sai.VLR_UNIT_CONV,
    nf_sai.VLR_ICMS_CONV,
    nf_sai.COD_MOTIVO_SAI,
    nf_sai.VLR_UNIT_ICMS_OPER_SAI,
    nf_sai.VLR_UNIT_ICMS_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_ESTQ_SAI,
    nf_sai.VLR_UNIT_FCP_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_REST_SAI,
    nf_sai.VLR_UNIT_FCP_REST_SAI,
    nf_sai.VLR_UNIT_ICMSS_COMPL_SAI,
    nf_sai.VLR_UNIT_FCP_COMPL_SAI,
    
    y2025.cod_situacao_a||y2026.cod_situacao_b as cst_icms,--1
    x2012.cod_cfo as cfop, --2
    
    x2013.GRUPO_PRODUTO,
    x2013.IND_PRODUTO,
    x2013.COD_PRODUTO,
   (SELECT x2007_PROD.COD_MEDIDA FROM X2007_MEDIDA x2007_PROD WHERE X2013.IDENT_MEDIDA = x2007_PROD.IDENT_MEDIDA) as COD_MEDIDA_PROD,
    X2043.COD_NBM  as COD_NBM_PROD,
    x2013.COD_CEST as COD_CEST_PROD,

    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'PRC_REDUCAO_BC')  as PRC_REDUCAO_BC,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_INTERNA')    as aliq_icms,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_FCP')        as ALIQ_FCP,
    x08.Quantidade       as QTD_X08,
    x08.Quantidade_Conv  as QTD_CONV_X08,
   (SELECT x2007_X08.GRUPO_MEDIDA FROM X2007_MEDIDA x2007_X08 WHERE x08.IDENT_MEDIDA = x2007_X08.IDENT_MEDIDA) as GRUPO_MEDIDA_X08,
   (SELECT x2007_X08.COD_MEDIDA FROM X2007_MEDIDA x2007_X08 WHERE x08.IDENT_MEDIDA = x2007_X08.IDENT_MEDIDA) as COD_MEDIDA_X08,
    x08.Vlr_Contab_Item as VLR_CONTAB_X08

From X296_INFO_COMPL_ST_ITENS_MERC nf_sai,
     X08_ITENS_MERC     x08,
     X2005_TIPO_DOCTO   x2005,
     X2013_PRODUTO      x2013,
     X2043_COD_NBM      X2043,
     X04_PESSOA_FIS_JUR x04,
     x07_docto_fiscal   x07,
     x2012_cod_fiscal   x2012,
     y2025_sit_trb_uf_a y2025,
     y2026_sit_trb_uf_b y2026

WHERE  nf_sai.COD_EMPRESA   = Pkg_Dados_Param.getCodEmpresa
AND    nf_sai.COD_ESTAB     = Pkg_Dados_Param.getCodEstab
AND    nf_sai.DATA_FISCAL   BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim
AND    nf_sai.movto_e_s     = '9'

AND    nf_sai.COD_EMPRESA = x08.COD_EMPRESA
AND    nf_sai.COD_ESTAB = x08.COD_ESTAB
AND    nf_sai.DATA_FISCAL = x08.DATA_FISCAL
AND    nf_sai.MOVTO_E_S = x08.MOVTO_E_S
AND    nf_sai.NORM_DEV = x08.NORM_DEV
AND    nf_sai.IDENT_DOCTO = x08.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    nf_sai.NUM_DOCFIS = x08.NUM_DOCFIS
AND    nf_sai.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    nf_sai.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS
AND    nf_sai.discri_item = x08.discri_item

AND    x07.COD_EMPRESA = x08.COD_EMPRESA
AND    x07.COD_ESTAB = x08.COD_ESTAB
AND    x07.DATA_FISCAL = x08.DATA_FISCAL
AND    x07.MOVTO_E_S = x08.MOVTO_E_S
AND    x07.NORM_DEV = x08.NORM_DEV
AND    x07.IDENT_DOCTO = x08.IDENT_DOCTO
AND    x07.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    x07.NUM_DOCFIS = x08.NUM_DOCFIS
AND    x07.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    x07.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS    

AND    nf_sai.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = X04.IDENT_FIS_JUR

AND    x08.ident_produto = x2013.ident_produto

and    x08.ident_cfo = x2012.ident_cfo

AND x08.ident_situacao_a = y2025.ident_situacao_a
AND x08.ident_situacao_b = y2026.ident_situacao_b

AND    X2043.IDENT_NBM (+) = X2013.IDENT_NBM

Order By nf_sai.COD_EMPRESA asc,
         nf_sai.COD_ESTAB asc,
         nf_sai.DATA_FISCAL asc,
         nf_sai.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) asc;
         

cursor c_mm_entradas is 
   SELECT
    'C180'as registro,
    nf_sai.COD_EMPRESA,
    nf_sai.COD_ESTAB,
    nf_sai.DATA_FISCAL,
    nf_sai.MOVTO_E_S,
    nf_sai.NORM_DEV,
    x07.num_autentic_nfe as chv_nfe,
    x2005.COD_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_sai.NUM_DOCFIS,
    nf_sai.SERIE_DOCFIS,
    nf_sai.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) as NUM_ITEM,
    nf_sai.QTD_CONV,
    (SELECT x2007_X296.COD_MEDIDA FROM X2007_MEDIDA x2007_X296 WHERE nf_sai.IDENT_MEDIDA = x2007_X296.IDENT_MEDIDA) as COD_MEDIDA,
    nf_sai.VLR_UNIT_CONV,
    nf_sai.VLR_ICMS_CONV,
    nf_sai.COD_MOTIVO_SAI,
    nf_sai.VLR_UNIT_ICMS_OPER_SAI,
    nf_sai.VLR_UNIT_ICMS_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_ESTQ_SAI,
    nf_sai.VLR_UNIT_FCP_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_REST_SAI,
    nf_sai.VLR_UNIT_FCP_REST_SAI,
    nf_sai.VLR_UNIT_ICMSS_COMPL_SAI,
    nf_sai.VLR_UNIT_FCP_COMPL_SAI,
    nf_sai.ind_resp_ret_ent,
    nf_sai.VLR_UNIT_BC_ICMSS_ENT,
    nf_sai.VLR_UNIT_ICMSS_CONV_ENT,
    nf_sai.VLR_UNIT_FCP_CONV_ENT,
    
    y2025.cod_situacao_a||y2026.cod_situacao_b as cst_icms,--1
    x2012.cod_cfo as cfop, --2
    
    x2013.GRUPO_PRODUTO,
    x2013.IND_PRODUTO,
    x2013.COD_PRODUTO,
   (SELECT x2007_PROD.COD_MEDIDA FROM X2007_MEDIDA x2007_PROD WHERE X2013.IDENT_MEDIDA = x2007_PROD.IDENT_MEDIDA) as ,
    X2043.COD_NBM   as COD_NBM_PROD,
    x2013.COD_CEST  as COD_CEST_PROD,

    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'PRC_REDUCAO_BC')  as PRC_REDUCAO_BC,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_INTERNA')    as aliq_icms,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_FCP')        as ALIQ_FCP,
    x08.Quantidade      as QTD_X08,
    x08.Quantidade_Conv  as QTD_CONV_X08,
   (SELECT x2007_X08.GRUPO_MEDIDA FROM X2007_MEDIDA x2007_X08 WHERE x08.IDENT_MEDIDA = x2007_X08.IDENT_MEDIDA) as GRUPO_MEDIDA_X08,
   (SELECT x2007_X08.COD_MEDIDA FROM X2007_MEDIDA x2007_X08 WHERE x08.IDENT_MEDIDA = x2007_X08.IDENT_MEDIDA) as COD_MEDIDA_X08,
    x08.Vlr_Contab_Item as VLR_CONTAB_X08

From X296_INFO_COMPL_ST_ITENS_MERC nf_sai,
     X08_ITENS_MERC     x08,
     X2005_TIPO_DOCTO   x2005,
     X2013_PRODUTO      x2013,
     X2043_COD_NBM      X2043,
     X04_PESSOA_FIS_JUR x04,
     x07_docto_fiscal   x07,
     x2012_cod_fiscal   x2012,
     y2025_sit_trb_uf_a y2025,
     y2026_sit_trb_uf_b y2026

WHERE  nf_sai.COD_EMPRESA   = Pkg_Dados_Param.getCodEmpresa
AND    nf_sai.COD_ESTAB     = Pkg_Dados_Param.getCodEstab
AND    nf_sai.DATA_FISCAL   BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim
AND    nf_sai.movto_e_s     <> '9'

AND    nf_sai.COD_EMPRESA = x08.COD_EMPRESA
AND    nf_sai.COD_ESTAB = x08.COD_ESTAB
AND    nf_sai.DATA_FISCAL = x08.DATA_FISCAL
AND    nf_sai.MOVTO_E_S = x08.MOVTO_E_S
AND    nf_sai.NORM_DEV = x08.NORM_DEV
AND    nf_sai.IDENT_DOCTO = x08.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    nf_sai.NUM_DOCFIS = x08.NUM_DOCFIS
AND    nf_sai.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    nf_sai.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS
AND    nf_sai.discri_item = x08.discri_item

AND    x07.COD_EMPRESA = x08.COD_EMPRESA
AND    x07.COD_ESTAB = x08.COD_ESTAB
AND    x07.DATA_FISCAL = x08.DATA_FISCAL
AND    x07.MOVTO_E_S = x08.MOVTO_E_S
AND    x07.NORM_DEV = x08.NORM_DEV
AND    x07.IDENT_DOCTO = x08.IDENT_DOCTO
AND    x07.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    x07.NUM_DOCFIS = x08.NUM_DOCFIS
AND    x07.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    x07.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS    

AND    nf_sai.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = X04.IDENT_FIS_JUR

AND    x08.ident_produto = x2013.ident_produto

and    x08.ident_cfo = x2012.ident_cfo

AND x08.ident_situacao_a = y2025.ident_situacao_a
AND x08.ident_situacao_b = y2026.ident_situacao_b

AND    X2043.IDENT_NBM (+) = X2013.IDENT_NBM

Order By nf_sai.COD_EMPRESA asc,
         nf_sai.COD_ESTAB asc,
         nf_sai.DATA_FISCAL asc,
         nf_sai.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) asc;     
     
cursor c_mm_inventario is    
SELECT 'H030' as registro,
                        x2013.cod_produto, 
                        x2007.cod_medida, 
                        x52.quantidade, 
                        x52.vlr_icms_medio, 
                        x52.vlr_base_icmss_medio, 
                        x52.vlr_icmss_medio, 
                        x52.vlr_fcp_medio
     FROM x52_invent_produto x52, x2013_produto x2013, x2007_medida x2007 --23/05/2024 x52_invent_produto 
    WHERE x52.ident_produto = x2013.ident_produto
    AND x52.ident_medida = x2007.ident_medida(+)
    AND cod_empresa = Pkg_Dados_Param.getCodEmpresa
    AND cod_estab = Pkg_Dados_Param.getCodEstab 
    AND data_inventario BETWEEN add_months(Pkg_Dados_Param.getDataIni,-1) AND add_months(Pkg_Dados_Param.getDataFim,-1)
    AND x52.ind_mot_inv = '06'
    and x52.grupo_contagem in ('1','2','3','5')
    AND nvl(x52.quantidade,0) > 0;
  
cursor c_mm_devolucao is    
SELECT x07.num_autentic_nfe as chv_nfe,
    x2013.cod_produto,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_sai.cod_empresa,nf_sai.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM,nf_sai.DATA_FISCAL, 'ALIQ_INTERNA')    as VLR_ALIQ_INT,
    'C181' as registro,
    nf_sai.COD_MOTIVO,
    nf_sai.QTD_CONV,
     x2007.COD_MEDIDA,
    nf_sai.COD_EMPRESA,
    nf_sai.COD_ESTAB,
    nf_sai.DATA_FISCAL,
    nf_sai.MOVTO_E_S,
    nf_sai.NORM_DEV,
    x2005.COD_DOCTO,
    nf_sai.IDENT_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_sai.IDENT_FIS_JUR,
    nf_sai.NUM_DOCFIS,
    nf_sai.SERIE_DOCFIS,
    nf_sai.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) as  NUM_ITEM,
    nf_sai.NUM_DOCFIS_REF,
    nf_sai.SERIE_DOCFIS_REF,
    nf_sai.SUB_SERIE_DOCFIS_REF,
    x2005a.COD_DOCTO as COD_DOCTO_REF,
    nf_sai.IDENT_DOCTO_REF,
    nf_sai.DATA_FISCAL_REF,
    nf_sai.NUM_ITEM_DOC_REF,
    nf_sai.ident_fis_jur_ref,
    nf_sai.data_emissao_ref,
   
    nf_sai.VLR_UNIT_CONV,
    nf_sai.VLR_ICMS_CONV,
    nf_sai.VLR_UNIT_ICMS_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMSS_ESTQ_SAI,
    nf_sai.VLR_UNIT_FCP_ESTQ_SAI,
    nf_sai.VLR_UNIT_ICMS_OPER_SAI,
    nf_sai.VLR_UNIT_ICMSS_REST_SAI,
    nf_sai.VLR_UNIT_FCP_REST_SAI,
    nf_sai.VLR_UNIT_ICMSS_COMPL_SAI,
    nf_sai.VLR_UNIT_FCP_COMPL_SAI,
    x2013.ind_produto as IND_PROD_NF_DEV,
    0 as VL_UNIT_ICMS_OP_CONV_SAIDA
From x308_info_compl_st_it_merc_dev nf_sai,
     x08_itens_merc       x08,
     x07_docto_fiscal     x07,
     X2005_TIPO_DOCTO     x2005,
     X2005_TIPO_DOCTO     x2005a,
     X2013_PRODUTO        x2013,
     X04_PESSOA_FIS_JUR   x04,
     X2007_MEDIDA         x2007,
     X2043_COD_NBM        X2043
WHERE  nf_sai.COD_EMPRESA     = Pkg_Dados_Param.getCodEmpresa
AND    nf_sai.COD_ESTAB       = Pkg_Dados_Param.getCodEstab 
AND    nf_sai.DATA_FISCAL     BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim

AND    nf_sai.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_sai.ident_docto_ref = x2005a.ident_docto

AND    X2043.IDENT_NBM (+) = X2013.IDENT_NBM

AND    nf_sai.COD_EMPRESA = x08.COD_EMPRESA
AND    nf_sai.COD_ESTAB = x08.COD_ESTAB
AND    nf_sai.DATA_FISCAL = x08.DATA_FISCAL
AND    nf_sai.MOVTO_E_S = x08.MOVTO_E_S
AND    nf_sai.NORM_DEV = x08.NORM_DEV
AND    nf_sai.IDENT_DOCTO = x08.IDENT_DOCTO
AND    nf_sai.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    nf_sai.NUM_DOCFIS = x08.NUM_DOCFIS
AND    nf_sai.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    nf_sai.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS
AND    nf_sai.discri_item = x08.discri_item

AND    x07.COD_EMPRESA = x08.COD_EMPRESA
AND    x07.COD_ESTAB = x08.COD_ESTAB
AND    x07.DATA_FISCAL = x08.DATA_FISCAL
AND    x07.MOVTO_E_S = x08.MOVTO_E_S
AND    x07.NORM_DEV = x08.NORM_DEV
AND    x07.IDENT_DOCTO = x08.IDENT_DOCTO
AND    x07.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    x07.NUM_DOCFIS = x08.NUM_DOCFIS
AND    x07.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    x07.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS    

AND    nf_sai.IDENT_FIS_JUR = X04.IDENT_FIS_JUR
AND    nf_sai.IDENT_MEDIDA = X2007.IDENT_MEDIDA(+)
AND    TO_NUMBER(SUBSTR(nf_sai.DISCRI_ITEM,1,12)) = X2013.IDENT_PRODUTO
AND    nf_sai.Cod_Motivo IN ('RJ500','RJ600','RJ800')

Order By nf_sai.COD_EMPRESA asc,
         nf_sai.COD_ESTAB asc,
         nf_sai.DATA_FISCAL asc,
         nf_sai.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_sai.DISCRI_ITEM) asc
; 

cursor c_mm_devolucao_ent is    
SELECT
    'C186' as registro,
    nf_ent.COD_EMPRESA,
    nf_ent.COD_ESTAB,
    x07.num_autentic_nfe as chv_nfe,
    nf_ent.DATA_FISCAL,
    nf_ent.MOVTO_E_S,
    nf_ent.NORM_DEV,
    x2005.COD_DOCTO,
    nf_ent.IDENT_DOCTO,
    x04.IND_FIS_JUR,
    x04.COD_FIS_JUR,
    nf_ent.IDENT_FIS_JUR,
    nf_ent.NUM_DOCFIS,
    nf_ent.SERIE_DOCFIS,
    nf_ent.SUB_SERIE_DOCFIS,
    WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_ent.DISCRI_ITEM) as NUM_ITEM,
    y2025.cod_situacao_a||y2026.cod_situacao_b as cst_icms,
    nf_ent.NUM_DOCFIS_REF,
    nf_ent.SERIE_DOCFIS_REF,
    nf_ent.SUB_SERIE_DOCFIS_REF,
    x2005a.COD_DOCTO as COD_DOCTO_REF,
    nf_ent.IDENT_DOCTO_REF,
    nf_ent.DATA_FISCAL_REF,
    nf_ent.NUM_ITEM_DOC_REF,
    nf_ent.ident_fis_jur_ref,
    nf_ent.data_emissao_ref,
    nf_ent.COD_MOTIVO as COD_MOT_REST_COMPL,
    nf_ent.QTD_CONV,
    x2007.COD_MEDIDA,
    nf_ent.VLR_UNIT_CONV,
    nf_ent.VLR_ICMS_CONV,
    nf_ent.vlr_unit_bc_icmss_ent,
    nf_ent.vlr_unit_icmss_conv_ent,
    nf_ent.vlr_unit_fcp_conv_ent,
    0 as VLR_ICMSS_CONV_ENT,
    x2013.ind_produto as IND_PROD_NF_DEV,
    x2013.cod_produto,
    x2012.cod_cfo as CFOP,
    WMX_SPED_RESSARC_RJ_REL.BuscaParam (nf_ent.cod_empresa,nf_ent.COD_ESTAB,x2013.GRUPO_PRODUTO,x2013.IND_PRODUTO,x2013.COD_PRODUTO
                                       ,X2043.COD_NBM, nf_ent.DATA_FISCAL, 'ALIQ_INTERNA')    as VLR_ALIQ_INT
From x308_info_compl_st_it_merc_dev nf_ent,
     x08_itens_merc       x08,
     x07_docto_fiscal     x07,
     X2005_TIPO_DOCTO     x2005,
     X2005_TIPO_DOCTO     x2005a,
     X2013_PRODUTO        x2013,
     X04_PESSOA_FIS_JUR   x04,
     X2007_MEDIDA         x2007,
     X2043_COD_NBM        X2043,
     y2025_sit_trb_uf_a   y2025,
     y2026_sit_trb_uf_b   y2026,
     x2012_cod_fiscal     x2012
WHERE  nf_ent.COD_EMPRESA     = Pkg_Dados_Param.getCodEmpresa
AND    nf_ent.COD_ESTAB       = Pkg_Dados_Param.getCodEstab
AND    nf_ent.DATA_FISCAL     BETWEEN Pkg_Dados_Param.getDataIni AND Pkg_Dados_Param.getDataFim

AND    nf_ent.IDENT_DOCTO = X2005.IDENT_DOCTO
AND    nf_ent.ident_docto_ref = x2005a.ident_docto

AND    X2043.IDENT_NBM (+) = X2013.IDENT_NBM

AND    nf_ent.COD_EMPRESA = x08.COD_EMPRESA
AND    nf_ent.COD_ESTAB = x08.COD_ESTAB
AND    nf_ent.DATA_FISCAL = x08.DATA_FISCAL
AND    nf_ent.MOVTO_E_S = x08.MOVTO_E_S
AND    nf_ent.NORM_DEV = x08.NORM_DEV
AND    nf_ent.IDENT_DOCTO = x08.IDENT_DOCTO
AND    nf_ent.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    nf_ent.NUM_DOCFIS = x08.NUM_DOCFIS
AND    nf_ent.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    nf_ent.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS
AND    nf_ent.discri_item = x08.discri_item

AND    x08.ident_situacao_a = y2025.ident_situacao_a
AND    x08.ident_situacao_b = y2026.ident_situacao_b

AND    x08.ident_cfo        = x2012.ident_cfo

AND    x07.COD_EMPRESA = x08.COD_EMPRESA
AND    x07.COD_ESTAB = x08.COD_ESTAB
AND    x07.DATA_FISCAL = x08.DATA_FISCAL
AND    x07.MOVTO_E_S = x08.MOVTO_E_S
AND    x07.NORM_DEV = x08.NORM_DEV
AND    x07.IDENT_DOCTO = x08.IDENT_DOCTO
AND    x07.IDENT_FIS_JUR = x08.IDENT_FIS_JUR
AND    x07.NUM_DOCFIS = x08.NUM_DOCFIS
AND    x07.SERIE_DOCFIS = x08.SERIE_DOCFIS
AND    x07.SUB_SERIE_DOCFIS = x08.SUB_SERIE_DOCFIS  

AND    nf_ent.IDENT_FIS_JUR = X04.IDENT_FIS_JUR
AND    nf_ent.IDENT_MEDIDA = X2007.IDENT_MEDIDA(+)
AND    TO_NUMBER(SUBSTR(nf_ent.DISCRI_ITEM,1,12)) = X2013.IDENT_PRODUTO
AND    nf_ent.Cod_Motivo IN ('RJ400')

Order By nf_ent.COD_EMPRESA asc,
         nf_ent.COD_ESTAB asc,
         nf_ent.DATA_FISCAL asc,
         nf_ent.NUM_DOCFIS asc,
         WMX_SPED_RESSARC_RJ_REL.BuscaNumItem(nf_ent.DISCRI_ITEM) asc
;



 -- Registros dos cursores

--  TYPE cREL_C180_NF_ENT             IS TABLE OF C_REL_C180_NF_ENT%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cREL_C186_NF_DEV_ENT         IS TABLE OF C_REL_C186_NF_DEV_ENT%ROWTYPE INDEX BY BINARY_INTEGER;
--  TYPE cREL_C185_C380_NF_SAI        IS TABLE OF C_REL_C185_C380_NF_SAI%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cREL_C181_NF_DEV_SAI         IS TABLE OF C_REL_C181_NF_DEV_SAI%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cREL_MEDIA_POND              IS TABLE OF C_REL_MEDIA_POND%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cREL_C185                    IS TABLE OF C_REL_C185%ROWTYPE INDEX BY BINARY_INTEGER;
  
  --meio magnetico
  TYPE cMM_SAI                    IS TABLE OF c_mm_saidas%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cMM_ENT                    IS TABLE OF c_mm_entradas%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cMM_INV                    IS TABLE OF c_mm_inventario%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cMM_DEV                    IS TABLE OF c_mm_devolucao%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE cMM_DEVEN                  IS TABLE OF c_mm_devolucao_ent%ROWTYPE INDEX BY BINARY_INTEGER;

--  rREL_C180_NF_ENT                  cREL_C180_NF_ENT;
  rREL_C186_NF_DEV_ENT              cREL_C186_NF_DEV_ENT;
--  rREL_C185_C380_NF_SAI             cREL_C185_C380_NF_SAI;
  rREL_C181_NF_DEV_SAI              cREL_C181_NF_DEV_SAI;
  rREL_MEDIA_POND                   cREL_MEDIA_POND;
  rREL_C185                         cREL_C185;
  
  --meio magnetico
  rMM_SAI                         cMM_SAI;
  rMM_ENT                         cMM_ENT;
  rMM_INV                         cMM_INV;
  rMM_DEV                         cMM_DEV;
  rMM_DEVEN                       cMM_DEVEN;

  /* executar
  */
  FUNCTION Executar (P_C181 in varchar2,P_C186 in varchar2,P_C195_C197 in varchar2,P_C185 in varchar2 ) RETURN INTEGER;


END WMX_SPED_RESSARC_RJ_REL;
/
CREATE OR REPLACE PACKAGE BODY WMX_SPED_RESSARC_RJ_REL IS

  -- global variables
  mCod_empresa          empresa.cod_empresa%TYPE;
  mCod_estab            estabelecimento.cod_estab%TYPE;
  mData_Ini             DATE;
  mData_Fim             DATE;
  mProc_id              INTEGER;
  mDataInv              DATE;

  linha_w               VARCHAR2(4000);
  Arquivo_w             VARCHAR2(150);

  vTab                  VARCHAR2(1) := chr(9);
  vExt                  VARCHAR2(5) := '.csv';


  Function FormataValor (pValor        In Varchar2,
                            pTipo         In Varchar2, -- 'C':alfanumérico, 'N': numérico
                            pTamanho      In Number,
                            pDecimal      In Number Default null) Return Varchar2 Is
     NumSep CONSTANT VARCHAR2(60) := 'nls_numeric_characters = '',.''';
     Numero Varchar2(100) := '9999999999999999999990';
     Result Varchar2(4000);
  Begin

      If pTipo = 'C' Then
         Result := Rpad(Nvl(pValor,' '), Nvl(pTamanho,0));
      Elsif pTipo = 'N' Then
         If pValor is null Then
           Result := Rpad(' ', Nvl(pTamanho,0));
         Else
           If Nvl(pDecimal,0) > 0 Then
              Numero := Numero || 'D' || Lpad('0',Nvl(pDecimal,0),'0');
              Result := To_Char(To_Number(Nvl(Ltrim(Rtrim(pValor)),0)),Numero,NumSep);
              --Result := Lpad(Nvl(Result,' '), Nvl(pTamanho,0));
           Else
              Result := Lpad(Nvl(Ltrim(Rtrim(pValor)),'0'), Nvl(pTamanho,0),'0');
           End If;
         End If;

      End If;

     Return (Result);
  Exception
     When Others Then
        Lib_Proc.Add_Log('Erro não previsto durante formatação da chave de identificação do log de erro. ' ||
                         'Mensagem do banco de dados: ' || SQLERRM, 0);
        Return (pValor);
  End FormataValor;


 FUNCTION formata_valor(p_valor NUMBER) RETURN VARCHAR2 IS
    cvNumSep CONSTANT VARCHAR2(60) := 'nls_numeric_characters = '', ''';
  BEGIN
    RETURN TRIM(TO_CHAR(p_valor, 'FM9999999999990D000000', cvNumSep)); 
  END formata_valor;

  PROCEDURE escreve_Arq(P_LINHA IN VARCHAR2, P_TIPO VARCHAR2) IS
   BEGIN

     LIB_PROC.ADD( plinha => P_LINHA
                 --, ppag => null
                 --, plin => null
                 , ptipo => P_TIPO
                 , pChaveOrdenacao => 0 );

   END ESCREVE_ARQ;

 FUNCTION BuscaNumItem(pDISCRI_ITEM in VARCHAR2) RETURN Integer IS
 BEGIN
    -- Recupera o Número do item pelo DISCRI_ITEM
   if LENGTH(pDISCRI_ITEM) = 25 then
     return SUBSTR(pDISCRI_ITEM, 13, 5);
   elsif LENGTH(pDISCRI_ITEM) = 71 then
     return SUBSTR(pDISCRI_ITEM, 67, 5);
   else
     return SUBSTR(pDISCRI_ITEM, 64, 5);
   end if;
 END BuscaNumItem;

/* buscaparam
*/
 Function BuscaParam (  pCOD_EMPRESA    IN VARCHAR2
                       ,pCOD_ESTAB      IN VARCHAR2
                       ,pGRUPO_PRODUTO  IN VARCHAR2
                       ,pIND_PRODUTO    IN VARCHAR2
                       ,pCOD_PRODUTO    IN VARCHAR2
                       ,pCOD_NBM        IN VARCHAR2
                       ,pDATA_EMISSAO   IN DATE
                       ,pIndCampo       IN VARCHAR2 )  Return NUMBER Is

ALIQ_INTERNA_w   EFD_PAR_PROD_C176.VLR_ALIQ_INT%TYPE;
ALIQ_FCP_w       EFD_PAR_PROD_C176.ALIQ_FCP%TYPE;
PRC_REDUCAO_BC_w EFD_PAR_PROD_C176.PRC_REDUCAO_BC%TYPE;
Count_Prod_w integer;

begin

     --VERIFICA SE EXISTE PRODUTO PARAMETRIZADO
         SELECT COUNT(1)
                     INTO Count_Prod_w
                   FROM  esp_sp_prod_st x104
                   WHERE  x104.COD_EMPRESA = pCOD_EMPRESA
                   and   x104.ident_estado = 20
                   AND x104.COD_PRODUTO = pCOD_PRODUTO
                   AND x104.IND_PRODUTO = pIND_PRODUTO
                   AND x104.GRUPO_produto = pGRUPO_PRODUTO;

    if nvl(Count_Prod_w,0) > 0 then-- produto
           SELECT    x104.aliq_interna,  x104.aliq_fcp,   x104.prc_reducao_bc 
           into   ALIQ_INTERNA_w  ,ALIQ_FCP_w  ,PRC_REDUCAO_BC_w
                   FROM  esp_sp_prod_st x104
                   WHERE  x104.COD_EMPRESA = pCOD_EMPRESA
                   and   x104.ident_estado = 20
                   and   x104.valid_inicial = TRUNC(pDATA_EMISSAO,'MM')                           
                   AND  x104.grupo_produto   = pGRUPO_PRODUTO
                   AND  x104.IND_PRODUTO = pIND_PRODUTO
                   AND  x104.COD_PRODUTO = pCOD_PRODUTO    ;
    Else-- nbm
      SELECT V.VLR_ALIQ_INT  ,V.ALIQ_FCP  ,V.PRC_REDUCAO_BC
      into   ALIQ_INTERNA_w  ,ALIQ_FCP_w  ,PRC_REDUCAO_BC_w
      FROM EFD_PAR_NBM_C176 V
      where V.COD_EMPRESA   = Pcod_empresa
      and   V.COD_ESTAB     = pCOD_ESTAB
      AND   V.COD_NBM       = pCOD_NBM
      AND  (V.DATA_FIM  >= pDATA_EMISSAO OR V.DATA_FIM IS NULL )
      AND   V.DATA_INI = (SELECT MAX(NCM.DATA_INI)
                             FROM   EFD_PAR_NBM_C176 NCM
                             WHERE  NCM.COD_EMPRESA    = V.COD_EMPRESA
                             AND    NCM.COD_ESTAB      = V.COD_ESTAB
                             AND    NCM.COD_NBM        = V.COD_NBM
                             AND    NCM.DATA_INI      <= pDATA_EMISSAO)
    ;
    end if;
    if pIndCampo = 'ALIQ_INTERNA' then
       Return ALIQ_INTERNA_w;
    elsif pIndCampo = 'ALIQ_FCP' then
       Return ALIQ_FCP_w;
    elsif pIndCampo = 'PRC_REDUCAO_BC' then
       Return PRC_REDUCAO_BC_w;
    end if;

exception
   when others then
        Return null;
end BuscaParam;

Function ConverteMedida (pCodMedDest in  X2007_MEDIDA.COD_MEDIDA%type,
                         pGrpProd    in x2013_produto.grupo_produto%type,
                         pIndProd    in x2013_produto.ind_produto%type,
                         pCodProd    in x2013_produto.cod_produto%type,
                         pGrpMed     in x2007_medida.grupo_medida%type,
                         pCodMed     in x2007_medida.cod_medida%type ) Return NUMBER Is

  pVlrFatorConv  DWT_CONV_MEDIDA2.Vlr_Fator_Conv%type;

  Begin

      Begin
        SELECT ConvMedProd.Vlr_Fator_Conv
          Into pVlrFatorConv
          FROM DWT_CONV_MEDIDA2 ConvMedProd
         WHERE ConvMedProd.Grupo_Produto   = pGrpProd
         and   ConvMedProd.Ind_Produto     = pIndProd
         and   ConvMedProd.Cod_Produto     = pCodProd
         and   ConvMedProd.Grupo_Medida    = pGrpMed
         and   UPPER(ConvMedProd.Cod_Medida_Orig) = UPPER(pCodMed)
         and   UPPER(ConvMedProd.Cod_Medida_Dest) = UPPER(pCodMedDest)
         and   ROWNUM = 1;

      Exception
        When NO_DATA_FOUND Then
          Begin
            SELECT ConvMed.Vlr_Fator_Conv
              Into pVlrFatorConv
              FROM DWT_CONV_MEDIDA ConvMed
             WHERE ConvMed.Grupo_Medida    = pGrpMed
             and   UPPER(ConvMed.Cod_Medida_Orig) = UPPER(pCodMed)
             and   UPPER(ConvMed.Cod_Medida_Dest) = UPPER(pCodMedDest)
             and   Rownum = 1;
          Exception
            When NO_DATA_FOUND Then
              Return 1;
          End;
      End;

     Return pVlrFatorConv;

  Exception
     When Others Then
        Return 1;
End ConverteMedida;

  PROCEDURE gera_REL_C185 IS
      VLR_FATOR_CONV_W DWT_CONV_MEDIDA2.Vlr_Fator_Conv%type;
      VLR_UNIT_BC_OP_ICMS_CONV_W X296_INFO_COMPL_ST_ITENS_MERC.VLR_ICMS_CONV%type;
   BEGIN

      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório C185=============================================',0);

      Arquivo_w := 'Relatorio_Conferencia_C185_'|| to_char(mData_Ini, 'MM') || '_' || to_char(mData_Ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 7, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Cod Empresa'|| vTab;  -- 001
      Linha_w := Linha_w ||'Cod Estab'|| vTab;  -- 002
      Linha_w := Linha_w ||'Dt Fiscal'|| vTab;  -- 003
      Linha_w := Linha_w ||'E/S'|| vTab;  -- 004
      Linha_w := Linha_w ||'Norm/Dev'|| vTab;  -- 005
      Linha_w := Linha_w ||'Cod Docto'|| vTab;  -- 006
      Linha_w := Linha_w ||'Ind Fis/Jur Cod Fis/Jur'|| vTab;  -- 007
      Linha_w := Linha_w ||'Num Docfis'|| vTab;  -- 008
      Linha_w := Linha_w ||'Serie'|| vTab;  -- 009
      Linha_w := Linha_w ||'SubSerie'|| vTab;  -- 010
      Linha_w := Linha_w ||'Num Item'|| vTab;  -- 011
      Linha_w := Linha_w ||'Qtde Conv (C185-07)'|| vTab;  -- 012
      Linha_w := Linha_w ||'Medida (C185-08)'|| vTab;  -- 013
      Linha_w := Linha_w ||'Vlr Unit Conv (C185-09)'|| vTab;  -- 014
      Linha_w := Linha_w ||'Vlr Unit ICMS Operação Conv (C185-10)'|| vTab;  -- 015
      Linha_w := Linha_w ||'Cod Motivo (C185-06)'|| vTab;  -- 016
      Linha_w := Linha_w ||'Vlr Unit ICMS Op Conv (C185-11)'|| vTab;  -- 017
      Linha_w := Linha_w ||'Vlr Unit ICMS Estoque Conv (C185-12)'|| vTab;  -- 018
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Estoque Conv (C185-13)'|| vTab;  -- 019
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Estoque Conv (C185-14)'|| vTab;  -- 020
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Conv Rest (C185-15)'|| vTab;  -- 021
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Conv Rest (C185-16)'|| vTab;  -- 022
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Conv Compl (C185-17)'|| vTab;  -- 023
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Conv Compl (C185-18)'|| vTab;  -- 024
      Linha_w := Linha_w ||'Ind Produto (SAFX2013-01) Cod Produto (SAFX2013-02)'|| vTab;  -- 025
      Linha_w := Linha_w ||'Medida Produto (SAFX2013-14)'|| vTab;  -- 026
      Linha_w := Linha_w ||'NCM Produto (SAFX2013-05)'|| vTab;  -- 027
      Linha_w := Linha_w ||'CEST Produto (SAFX2013-54)'|| vTab;  -- 028
      Linha_w := Linha_w ||'%Redução BC (Parametrização Produto)'|| vTab;  -- 029
      Linha_w := Linha_w ||'Alíq. Interna (Parametrização Produto)'|| vTab;  -- 030
      Linha_w := Linha_w ||'Alíq. FCP (Parametrização Produto)'|| vTab;  -- 031
      Linha_w := Linha_w ||'Qtde Item (SAFX08-24)'|| vTab;  -- 032
      Linha_w := Linha_w ||'Qtde Conv Item (SAFX08-137)'|| vTab;  -- 033
      Linha_w := Linha_w ||'Medida Item (SAFX08-25)'|| vTab;  -- 034
      Linha_w := Linha_w ||'Fator Conv (Cadastro Conversão Medida)'|| vTab;  -- 035
      Linha_w := Linha_w ||'Vlr Contabil Item (SAFX08-64)'|| vTab;  -- 037
      Linha_w := Linha_w ||'Vlr Unit BC ICMS Operação Conv (Vlr Contábil c/ %Redução BC)';  -- 038

     ESCREVE_ARQ(Linha_w, 7);

     OPEN C_REL_C185 ;

     LOOP
       FETCH C_REL_C185 BULK COLLECT INTO rREL_C185 LIMIT 500;
       EXIT WHEN rREL_C185.COUNT = 0;

       FOR I IN rREL_C185.FIRST .. rREL_C185.LAST LOOP

         -- Recupera Fator se Conversão
         If rREL_C185(I).COD_MEDIDA_PROD <> rREL_C185(I).COD_MEDIDA_X08 then

             VLR_FATOR_CONV_W := ConverteMedida( rREL_C185(I).COD_MEDIDA_PROD,
                                                 rREL_C185(I).GRUPO_PRODUTO,
                                                 rREL_C185(I).IND_PRODUTO,
                                                 rREL_C185(I).COD_PRODUTO,
                                                 rREL_C185(I).GRUPO_MEDIDA_X08,
                                                 rREL_C185(I).COD_MEDIDA_X08);
          Else
             VLR_FATOR_CONV_W := 1;
          End If;

          --
          VLR_UNIT_BC_OP_ICMS_CONV_W := trunc((coalesce(rREL_C185(I).VLR_CONTAB_X08,0) -
                                       (coalesce(rREL_C185(I).VLR_CONTAB_X08,0) * (coalesce(rREL_C185(I).PRC_REDUCAO_BC, 0)/100))),6);

         LINHA_W := rREL_C185(I).COD_EMPRESA  -- 001
                    ||vTab|| rREL_C185(I).COD_ESTAB  -- 002
                    ||vTab|| rREL_C185(I).DATA_FISCAL  -- 003
                    ||vTab|| rREL_C185(I).MOVTO_E_S  -- 004
                    ||vTab|| rREL_C185(I).NORM_DEV  -- 005
                    ||vTab|| rREL_C185(I).COD_DOCTO  -- 006
                    ||vTab|| rREL_C185(I).IND_FIS_JUR ||'-'|| rREL_C185(I).COD_FIS_JUR  -- 007
                    ||vTab|| rREL_C185(I).NUM_DOCFIS  -- 008
                    ||vTab|| rREL_C185(I).SERIE_DOCFIS  -- 009
                    ||vTab|| rREL_C185(I).SUB_SERIE_DOCFIS  -- 010
                    ||vTab|| rREL_C185(I).NUM_ITEM  -- 011
                    ||vTab|| FormataValor(rREL_C185(I).QTD_CONV, 'N', 17, 6)  -- 012
                    ||vTab|| rREL_C185(I).COD_MEDIDA  -- 013
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_CONV, 'N', 19, 6)  -- 014
                    ||vTab|| FormataValor(rREL_C185(I).VLR_ICMS_CONV, 'N', 19, 6)  -- 015
                    ||vTab|| rREL_C185(I).COD_MOTIVO_SAI  -- 016
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_ICMS_OPER_SAI, 'N', 19, 6)  -- 017
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_ICMS_ESTQ_SAI, 'N', 19, 6)  -- 018
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_ICMSS_ESTQ_SAI, 'N', 19, 6)  -- 019
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_FCP_ESTQ_SAI, 'N', 19, 6)  -- 020
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_ICMSS_REST_SAI, 'N', 19, 6)  -- 021
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_FCP_REST_SAI, 'N', 19, 6)  -- 022
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_ICMSS_COMPL_SAI, 'N', 19, 6)  -- 023
                    ||vTab|| FormataValor(rREL_C185(I).VLR_UNIT_FCP_COMPL_SAI, 'N', 19, 6)  -- 024
                    ||vTab|| rREL_C185(I).IND_PRODUTO ||'-'||rREL_C185(I).COD_PRODUTO  -- 025
                    ||vTab|| rREL_C185(I).COD_MEDIDA_PROD  -- 026
                    ||vTab|| rREL_C185(I).COD_NBM_PROD  -- 027
                    ||vTab|| rREL_C185(I).COD_CEST_PROD  -- 028
                    ||vTab|| FormataValor(rREL_C185(I).PRC_REDUCAO_BC, 'N', 7, 4)  -- 029
                    ||vTab|| FormataValor(rREL_C185(I).ALIQ_INTERNA, 'N', 7, 4)  -- 030
                    ||vTab|| FormataValor(rREL_C185(I).ALIQ_FCP, 'N', 7, 4)  -- 031
                    ||vTab|| FormataValor(rREL_C185(I).QTD_X08, 'N', 17, 6)  -- 032
                    ||vTab|| FormataValor(rREL_C185(I).QTD_CONV_X08, 'N', 17, 6)  -- 033
                    ||vTab|| rREL_C185(I).COD_MEDIDA_X08  -- 034
                    ||vTab|| FormataValor(VLR_FATOR_CONV_W, 'N', 17, 6) -- 035
                    ||vTab|| FormataValor(rREL_C185(I).VLR_CONTAB_X08, 'N', 19, 6)  -- 036
                    ||vTab|| FormataValor(VLR_UNIT_BC_OP_ICMS_CONV_W, 'N', 19, 6);  -- 037

         ESCREVE_ARQ(LINHA_W, 7);

       END LOOP;

       commit;

     End Loop; -- Fim da leitura cursor
     CLOSE C_REL_C185;

     Lib_proc.add_log('Geração do Relatório C185 realizada com sucesso. ',0);

  EXCEPTION
    WHEN OTHERS THEN
      Lib_Proc.Add_Log ('Erro ao gerar o Relatorio EST_RESSARC_RS_IN087_Rel.gera_rel_c185.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
      If C_REL_C185%ISOPEN Then  -- Verifica se cursor está aberto
       Close C_REL_C185;
      End If;
  END gera_REL_C185;

  PROCEDURE gera_rel_C181_nf_dev_sai IS
   BEGIN

      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório C181=============================================',0);

      Arquivo_w := 'Relatorio_Conferencia_C181_' || to_char(mData_Ini, 'MM') || '_' || to_char(mData_Ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 5, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Cod Empresa'|| vTab;  -- 001
      Linha_w := Linha_w ||'Cod Estab'|| vTab;  -- 002
      Linha_w := Linha_w ||'Dt Fiscal NF Devolução'|| vTab;  -- 003
      Linha_w := Linha_w ||'E/S NF Devolução'|| vTab;  -- 004
      Linha_w := Linha_w ||'Norm/Dev NF Devolução'|| vTab;  -- 005
      Linha_w := Linha_w ||'Cod Docto NF Devolução'|| vTab;  -- 006
      Linha_w := Linha_w ||'Ind Fis/Jur NF Devolução Cod Fis/Jur NF Devolução'|| vTab;  -- 007
      Linha_w := Linha_w ||'Num Docfis NF Devolução'|| vTab;  -- 008
      Linha_w := Linha_w ||'Serie NF Devolução'|| vTab;  -- 009
      Linha_w := Linha_w ||'SubSerie NF Devolução'|| vTab;  -- 010
      Linha_w := Linha_w ||'Ind Produto (SAFX2013-01) Cod Produto (SAFX2013-02)'|| vTab;  -- 031
      Linha_w := Linha_w ||'Num Item NF Devolução'|| vTab;  -- 011
      Linha_w := Linha_w ||'Num Docfis NF Saída (C181-08)'|| vTab;  -- 012
      Linha_w := Linha_w ||'Serie NF Saída (C181-06)'|| vTab;  -- 013
      Linha_w := Linha_w ||'SubSerie NF Saída'|| vTab;  -- 014
      Linha_w := Linha_w ||'Cod Docto NF Saída'|| vTab;  -- 015
      Linha_w := Linha_w ||'Dt Fiscal NF Saída (C181-10)'|| vTab;  -- 016
      Linha_w := Linha_w ||'Num Item NF Saída (C181-11)'|| vTab;  -- 017
      Linha_w := Linha_w ||'Cod Motivo (C181-02)'|| vTab;  -- 018
      Linha_w := Linha_w ||'Qtde Conv (C181-03)'|| vTab;  -- 019
      Linha_w := Linha_w ||'Medida (C181-04)'|| vTab;  -- 020
      Linha_w := Linha_w ||'Vlr Unit Conv (C181-12)'|| vTab;  -- 021
      Linha_w := Linha_w ||'Vlr Unit ICMS Op Conv (C181-17)'|| vTab;  -- 022
      Linha_w := Linha_w ||'Vlr Unit ICMS Estoque Conv (C181-13)'|| vTab;  -- 023
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Estoque Conv (C181-14)'|| vTab;  -- 024
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Estoque Conv (C181-15)'|| vTab;  -- 025
      Linha_w := Linha_w ||'Vlr Unit ICMS Operação Conv (C181-16)'|| vTab;  -- 026
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Conv Rest (C181-18)'|| vTab;  -- 027
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Conv Rest (C181-19)'|| vTab;  -- 028
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Conv Compl (C181-20)'|| vTab;  -- 029
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Conv Compl (C181-21)'|| vTab;  -- 030


      ESCREVE_ARQ(Linha_w, 5);

       OPEN C_REL_C181_NF_DEV_SAI;

       LOOP
         FETCH C_REL_C181_NF_DEV_SAI BULK COLLECT INTO rREL_C181_NF_DEV_SAI LIMIT 500;
         EXIT WHEN rREL_C181_NF_DEV_SAI.COUNT = 0;

         FOR I IN rREL_C181_NF_DEV_SAI.FIRST .. rREL_C181_NF_DEV_SAI.LAST LOOP

           LINHA_W := rREL_C181_NF_DEV_SAI(I).COD_EMPRESA  -- 001
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).COD_ESTAB  -- 002
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).DATA_FISCAL  -- 003
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).MOVTO_E_S  -- 004
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).NORM_DEV  -- 005
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).COD_DOCTO  -- 006
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).IND_FIS_JUR || '-' || rREL_C181_NF_DEV_SAI(I).COD_FIS_JUR  -- 007
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).NUM_DOCFIS  -- 008
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).SERIE_DOCFIS  -- 009
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).SUB_SERIE_DOCFIS  -- 010
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).IND_PROD_NF_DEV || '-' || rREL_C181_NF_DEV_SAI(I).COD_PROD_NF_DEV  -- 031
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).NUM_ITEM  -- 011
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).NUM_DOCFIS_REF  -- 012
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).SERIE_DOCFIS_REF  -- 013
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).SUB_SERIE_DOCFIS_REF  -- 014
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).COD_DOCTO_REF  -- 015
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).DATA_FISCAL_REF  -- 016
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).NUM_ITEM_DOC_REF  -- 017
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).COD_MOTIVO  -- 018
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).QTD_CONV, 'N', 17, 6)  -- 019
                      ||vTab|| rREL_C181_NF_DEV_SAI(I).COD_MEDIDA  -- 020
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_CONV, 'N', 19, 6)  -- 021
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_ICMS_CONV, 'N', 19, 6)  -- 022
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_ICMS_ESTQ_SAI, 'N', 19, 6)  -- 023
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_ICMSS_ESTQ_SAI, 'N', 19, 6)  -- 024
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_FCP_ESTQ_SAI, 'N', 19, 6)  -- 025
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_ICMS_OPER_SAI, 'N', 19, 6)  -- 026
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_ICMSS_REST_SAI, 'N', 19, 6)  -- 027
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_FCP_REST_SAI, 'N', 19, 6)  -- 028
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_ICMSS_COMPL_SAI, 'N', 19, 6)  -- 029
                      ||vTab|| FormataValor(rREL_C181_NF_DEV_SAI(I).VLR_UNIT_FCP_COMPL_SAI, 'N', 19, 6)  -- 030
                      ;
                   ESCREVE_ARQ(LINHA_W, 5);

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_REL_C181_NF_DEV_SAI;

       Lib_proc.add_log('Geração do Relatório C181 realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o Relatorio EST_RESSARC_RS_IN087_Rel.gera_rel_c181_nf_dev_sai.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
        If C_REL_C181_NF_DEV_SAI%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_REL_C181_NF_DEV_SAI;
        End If;
   END gera_rel_C181_nf_dev_sai;

PROCEDURE gera_MM IS
   V_VLR_UNIT_FCP_REST_SAI       x296_info_compl_st_itens_merc.VLR_UNIT_FCP_ESTQ_SAI%TYPE := 0;
   V_VLR_UNIT_FCP_COMPL_SAI      x296_info_compl_st_itens_merc.VLR_UNIT_FCP_COMPL_SAI%TYPE :=0;
   v_cod_modelo_ref              x2024_modelo_docto.cod_modelo%TYPE;
   v_num_autentic_nfe_ref        x07_docto_fiscal.num_autentic_nfe%TYPE; 
   v_data_emissao_ref            x07_docto_fiscal.data_emissao%TYPE;
   
   BEGIN

      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================MEIO MAGNETICO=============================================',0);

      Arquivo_w := mcod_empresa || '-' || mCod_estab || '-' ||  to_char(mData_Ini, 'MM') || to_char(mData_Ini, 'YYYY')||'.txt';
      lib_proc.add_tipo(mProc_Id, 22, Arquivo_w, 2);
 
     --Entradas
     begin
       OPEN C_MM_ENTRADAS;

       LOOP
         FETCH C_MM_ENTRADAS BULK COLLECT INTO rMM_ENT LIMIT 500;
         EXIT WHEN rMM_ENT.COUNT = 0;

         FOR I IN rMM_ENT.FIRST .. rMM_ENT.LAST LOOP
           
          LINHA_W :=  rMM_ENT(I).chv_nfe|| ';' || rMM_ENT(I).cod_produto || ';' ||
                           formata_valor(rMM_ENT(I).aliq_icms) || ';' || rMM_ENT(I).registro|| ';' || 
                           rMM_ENT(I).ind_resp_ret_ent || ';' ||
                           rMM_ENT(I).qtd_conv|| ';' ||
                           rMM_ENT(I).cod_medida|| ';' ||
                           formata_valor(rMM_ENT(I).vlr_unit_conv)|| ';' ||
                           formata_valor(rMM_ENT(I).vlr_icms_conv)|| ';' || 
                           formata_valor(rMM_ENT(I).VLR_UNIT_BC_ICMSS_ENT)|| ';' ||
                           formata_valor(rMM_ENT(I).VLR_UNIT_ICMSS_CONV_ENT)|| ';' || 
                           formata_valor(rMM_ENT(I).VLR_UNIT_FCP_CONV_ENT)|| ';' ||
                           '@'|| ';' ||
                           '@';
      

          
                   ESCREVE_ARQ(LINHA_W, 22);

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_MM_ENTRADAS;
        exception when others then
         Lib_Proc.Add_Log ('Erro ao gerar o MM Entradas.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
         If C_MM_ENTRADAS%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_MM_ENTRADAS;
        End If;
       end;
       
       
     --Devolucao Saidas
     begin
       OPEN C_MM_DEVOLUCAO;

       LOOP
         FETCH C_MM_DEVOLUCAO BULK COLLECT INTO rMM_DEV LIMIT 500;
         EXIT WHEN rMM_DEV.COUNT = 0;

         FOR I IN rMM_DEV.FIRST .. rMM_DEV.LAST LOOP
           
          BEGIN
            SELECT x2024.cod_modelo as cod_modelo_ref,
                   xx.num_autentic_nfe as num_autentic_nfe_ref
              INTO v_cod_modelo_ref, 
                   v_num_autentic_nfe_ref 
             FROM x07_docto_fiscal xx, x2024_modelo_docto x2024
              WHERE xx.cod_empresa = rMM_DEV(I).cod_empresa
              AND xx.Cod_Estab = rMM_DEV(I).Cod_Estab
              AND xx.data_fiscal = rMM_DEV(I).DATA_FISCAL_REF
              AND xx.movto_e_s = '9'
              AND xx.num_docfis = rMM_DEV(I).NUM_DOCFIS_REF
              AND xx.serie_docfis = rMM_DEV(I).SERIE_DOCFIS_REF
              AND xx.sub_serie_docfis = rMM_DEV(I).SUB_SERIE_DOCFIS_REF
              AND xx.ident_docto = rMM_DEV(I).ident_docto_ref
              AND xx.ident_fis_jur = rMM_DEV(I).ident_fis_jur_ref
              AND xx.ident_modelo = x2024.ident_modelo;
 
          EXCEPTION WHEN OTHERS THEN
             Lib_Proc.Add_Log ('Nao encontrei dados da nF de referencia ' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
             v_cod_modelo_ref := NULL; 
             v_num_autentic_nfe_ref := NULL;
          END;
         
           IF rMM_DEV(I).COD_MOTIVO = 'RJ800' THEN
              V_VLR_UNIT_FCP_REST_SAI := rMM_DEV(I).VLR_UNIT_FCP_ESTQ_SAI;
              V_VLR_UNIT_FCP_COMPL_SAI := 0;
           ELSIF rMM_DEV(I).COD_MOTIVO = 'RJ600' THEN
              V_VLR_UNIT_FCP_COMPL_SAI := rMM_DEV(I).VLR_UNIT_FCP_ESTQ_SAI;
              V_VLR_UNIT_FCP_REST_SAI := 0;
           END IF;
         
         
         
          LINHA_W := rMM_DEV(I).chv_nfe|| ';' || rMM_DEV(I).cod_produto || ';' ||
                           formata_valor(rMM_DEV(I).VLR_ALIQ_INT) || ';' || rMM_DEV(I).registro|| ';' || 
                           rMM_DEV(I).COD_MOTIVO|| ';' || rMM_DEV(I).qtd_conv|| ';' || 
                           rMM_DEV(I).cod_medida|| ';' || v_cod_modelo_ref || ';' ||
                           NULL|| ';' ||NULL|| ';' ||rMM_DEV(I).NUM_DOCFIS_REF|| ';' ||
                           v_num_autentic_nfe_ref || ';' ||rMM_DEV(I).DATA_FISCAL_REF|| ';' ||
                           rMM_DEV(I).NUM_ITEM_DOC_REF || ';' ||
                           formata_valor(rMM_DEV(I).vlr_unit_conv)|| ';' ||
                           formata_valor(rMM_DEV(I).vlr_unit_icms_estq_sai)|| ';' || 
                           formata_valor(rMM_DEV(I).vlr_unit_icmss_estq_sai)|| ';' || 
                           formata_valor(rMM_DEV(I).VLR_UNIT_FCP_ESTQ_SAI)|| ';' || 
                           formata_valor(rMM_DEV(I).vlr_unit_icms_oper_sai)|| ';' ||
                           formata_valor(rMM_DEV(I).VL_UNIT_ICMS_OP_CONV_SAIDA)|| ';' ||
                           formata_valor(rMM_DEV(I).vlr_unit_icmss_rest_sai)|| ';' || 
                           formata_valor(V_VLR_UNIT_FCP_REST_SAI)|| ';' || 
                           formata_valor(rMM_DEV(I).VLR_UNIT_ICMSS_COMPL_SAI)|| ';' ||
                           formata_valor(V_VLR_UNIT_FCP_COMPL_SAI) ;
      

          
                   ESCREVE_ARQ(LINHA_W, 22);
                   V_VLR_UNIT_FCP_REST_SAI := 0;
                   V_VLR_UNIT_FCP_COMPL_SAI := 0;

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_MM_DEVOLUCAO;
        exception when others then
         Lib_Proc.Add_Log ('Erro ao gerar o MM Devolucao.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
         If C_MM_DEVOLUCAO%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_MM_DEVOLUCAO;
        End If;
       end;
       
     --Devolucao entradas
     begin
       OPEN C_MM_DEVOLUCAO_ENT;

       LOOP
         FETCH C_MM_DEVOLUCAO_ENT BULK COLLECT INTO rMM_DEVEN LIMIT 500;
         EXIT WHEN rMM_DEVEN.COUNT = 0;

         FOR I IN rMM_DEVEN.FIRST .. rMM_DEVEN.LAST LOOP
           
          BEGIN
            SELECT x2024.cod_modelo as cod_modelo_ref,
                   xx.num_autentic_nfe as num_autentic_nfe_ref,
                   xx.data_emissao
              INTO v_cod_modelo_ref, 
                   v_num_autentic_nfe_ref,
                   v_data_emissao_ref
             FROM x07_docto_fiscal xx, x2024_modelo_docto x2024
              WHERE xx.cod_empresa = rMM_DEVEN(I).cod_empresa
              AND xx.Cod_Estab = rMM_DEVEN(I).Cod_Estab
              AND xx.data_fiscal = rMM_DEVEN(I).DATA_FISCAL_REF
              AND xx.movto_e_s <> '9'
              AND xx.num_docfis = rMM_DEVEN(I).NUM_DOCFIS_REF
              AND xx.serie_docfis = rMM_DEVEN(I).SERIE_DOCFIS_REF
              AND xx.sub_serie_docfis = rMM_DEVEN(I).SUB_SERIE_DOCFIS_REF
              AND xx.ident_docto = rMM_DEVEN(I).ident_docto_ref
              AND xx.ident_fis_jur = rMM_DEVEN(I).ident_fis_jur_ref
              AND xx.ident_modelo = x2024.ident_modelo;
 
          EXCEPTION WHEN OTHERS THEN
             Lib_Proc.Add_Log ('Nao encontrei dados da nF de referencia DEV_EN ' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
             v_cod_modelo_ref := NULL; 
             v_num_autentic_nfe_ref := NULL;
             v_data_emissao_ref := NULL;
          END;
          
         
          LINHA_W := rMM_DEVEN(I).chv_nfe|| ';' ||
                           formata_valor(rMM_DEVEN(I).VLR_ALIQ_INT) || ';' || rMM_DEVEN(I).registro|| ';' || 
                           rMM_DEVEN(I).NUM_ITEM|| ';' || rMM_DEVEN(I).cod_produto || ';' || 
                           rMM_DEVEN(I).cst_icms|| ';' || rMM_DEVEN(I).CFOP|| ';' || 
                           rMM_DEVEN(I).COD_MOT_REST_COMPL|| ';' || 
                           rMM_DEVEN(I).qtd_conv|| ';' || 
                           rMM_DEVEN(I).cod_medida|| ';' || v_cod_modelo_ref || ';' ||
                           NULL|| ';' ||NULL|| ';' ||v_num_autentic_nfe_ref || ';' ||
                           v_data_emissao_ref|| ';' ||
                           rMM_DEVEN(I).NUM_ITEM_DOC_REF || ';' || 
                           formata_valor(rMM_DEVEN(I).vlr_unit_conv)|| ';' ||
                           formata_valor(rMM_DEVEN(I).VLR_ICMS_CONV)|| ';' ||
                           formata_valor(rMM_DEVEN(I).VLR_UNIT_BC_ICMSS_ENT)|| ';' || 
                           formata_valor(rMM_DEVEN(I).vlr_unit_icmss_conv_ent)|| ';' || 
                           formata_valor(rMM_DEVEN(I).VLR_UNIT_FCP_CONV_ENT);
       

          
                   ESCREVE_ARQ(LINHA_W, 22);

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_MM_DEVOLUCAO_ENT;
        exception when others then
         Lib_Proc.Add_Log ('Erro ao gerar o MM Devolucao Entradas.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
         If C_MM_DEVOLUCAO_ENT%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_MM_DEVOLUCAO_ENT;
        End If;
       end;
       
       --Saidas
       V_VLR_UNIT_FCP_REST_SAI := 0;
       V_VLR_UNIT_FCP_COMPL_SAI := 0;
       begin
       OPEN C_MM_SAIDAS;

       LOOP
         FETCH C_MM_SAIDAS BULK COLLECT INTO rMM_SAI LIMIT 500;
         EXIT WHEN rMM_SAI.COUNT = 0;

         FOR I IN rMM_SAI.FIRST .. rMM_SAI.LAST LOOP
         
           IF rMM_SAI(I).cod_motivo_sai = 'RJ100' THEN
              V_VLR_UNIT_FCP_REST_SAI := rMM_SAI(I).vlr_unit_fcp_estq_sai;
              V_VLR_UNIT_FCP_COMPL_SAI := 0;
           ELSIF rMM_SAI(I).cod_motivo_sai = 'RJ300' THEN
              V_VLR_UNIT_FCP_COMPL_SAI := rMM_SAI(I).vlr_unit_fcp_estq_sai;
              V_VLR_UNIT_FCP_REST_SAI := 0;
           END IF;
           
          LINHA_W :=  rMM_SAI(I).chv_nfe || ';' || formata_valor(rMM_SAI(I).aliq_icms) || ';' ||rMM_SAI(I).registro|| ';' ||rMM_SAI(I).num_item|| ';' ||
                           rMM_SAI(I).cod_produto || ';' || rMM_SAI(I).cst_icms|| ';' || rMM_SAI(I).cfop || ';' ||rMM_SAI(I).cod_motivo_sai || ';' ||
                           rMM_SAI(I).qtd_conv|| ';' ||rMM_SAI(I).cod_medida|| ';' ||formata_valor(rMM_SAI(I).vlr_unit_conv)
                           || ';' ||formata_valor(rMM_SAI(I).vlr_icms_conv)|| ';' || formata_valor(rMM_SAI(I).vlr_unit_icms_estq_sai) || ';' || 
                           formata_valor(rMM_SAI(I).vlr_unit_icmss_estq_sai)|| ';' || formata_valor(rMM_SAI(I).vlr_unit_fcp_estq_sai)|| ';' || 
                           formata_valor(rMM_SAI(I).vlr_unit_icmss_rest_sai) || ';' || formata_valor(V_VLR_UNIT_FCP_REST_SAI) || ';' || 
                           formata_valor(rMM_SAI(I).vlr_unit_icmss_compl_sai) || ';' ||  formata_valor(V_VLR_UNIT_FCP_COMPL_SAI);
      
      

          
                   ESCREVE_ARQ(LINHA_W, 22);
                   V_VLR_UNIT_FCP_REST_SAI := 0;
                   V_VLR_UNIT_FCP_COMPL_SAI := 0;

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_MM_SAIDAS;
        exception when others then
         Lib_Proc.Add_Log ('Erro ao gerar o MM SAIDAS.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
         If C_MM_SAIDAS%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_MM_SAIDAS;
        End If;
       end;
       
       --inventario
       begin
       OPEN C_MM_INVENTARIO;

       LOOP
         FETCH C_MM_INVENTARIO BULK COLLECT INTO rMM_INV LIMIT 500;
         EXIT WHEN rMM_INV.COUNT = 0;

         FOR I IN rMM_INV.FIRST .. rMM_INV.LAST LOOP
           
          LINHA_W := rMM_INV(I).cod_produto || ';' ||  rMM_INV(I).cod_medida || ';' ||rMM_INV(I).quantidade|| ';' ||rMM_INV(I).registro|| ';' ||
                     formata_valor(rMM_INV(I).VLR_ICMS_MEDIO) || ';' || formata_valor(rMM_INV(I).VLR_BASE_ICMSS_MEDIO)|| ';' || formata_valor(rMM_INV(I).VLR_ICMSS_MEDIO)|| ';' ||formata_valor(rMM_INV(I).VLR_FCP_MEDIO);
      
      

          
                   ESCREVE_ARQ(LINHA_W, 22);

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_MM_INVENTARIO;
       exception when others then
         Lib_Proc.Add_Log ('Erro ao gerar o MM Inventario.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
         If C_MM_INVENTARIO%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_MM_INVENTARIO;
        End If;
       end;

       Lib_proc.add_log('Geração do Relatório MM realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o MM.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
   END gera_MM;

  PROCEDURE gera_rel_C186_nf_dev_ent IS
   BEGIN

      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório C186=============================================',0);

      Arquivo_w := 'Relatorio_Conferencia_C186_' || to_char(mData_Ini, 'MM') || '_' || to_char(mData_Ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 6, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Cod Empresa'|| vTab;  -- 001
      Linha_w := Linha_w ||'Cod Estab'|| vTab;  -- 002
      Linha_w := Linha_w ||'Dt Fiscal NF Devolução'|| vTab;  -- 003
      Linha_w := Linha_w ||'E/S NF Devolução'|| vTab;  -- 004
      Linha_w := Linha_w ||'Norm/Dev NF Devolução'|| vTab;  -- 005
      Linha_w := Linha_w ||'Cod Docto NF Devolução'|| vTab;  -- 006
      Linha_w := Linha_w ||'Ind Fis/Jur NF Devolução Cod Fis/Jur NF Devolução'|| vTab;  -- 007
      Linha_w := Linha_w ||'Num Docfis NF Devolução'|| vTab;  -- 008
      Linha_w := Linha_w ||'Serie NF Devolução'|| vTab;  -- 009
      Linha_w := Linha_w ||'SubSerie NF Devolução'|| vTab;  -- 010
      Linha_w := Linha_w ||'Ind Produto (SAFX2013-01) Cod Produto (SAFX2013-02)'|| vTab;  -- 031
      Linha_w := Linha_w ||'Num Item NF Devolução'|| vTab;  -- 011
      Linha_w := Linha_w ||'Num Docfis NF Saída (C186-08)'|| vTab;  -- 012
      Linha_w := Linha_w ||'Serie NF Saída (C186-06)'|| vTab;  -- 013
      Linha_w := Linha_w ||'SubSerie NF Saída'|| vTab;  -- 014
      Linha_w := Linha_w ||'Cod Docto NF Saída'|| vTab;  -- 015
      Linha_w := Linha_w ||'Dt Fiscal NF Saída (C186-10)'|| vTab;  -- 016
      Linha_w := Linha_w ||'Num Item NF Saída (C186-11)'|| vTab;  -- 017
      Linha_w := Linha_w ||'Cod Motivo (C186-02)'|| vTab;  -- 018
      Linha_w := Linha_w ||'Qtde Conv (C186-03)'|| vTab;  -- 019
      Linha_w := Linha_w ||'Medida (C186-04)'|| vTab;  -- 020
      Linha_w := Linha_w ||'Vlr Unit Conv (C186-12)'|| vTab;  -- 021
      Linha_w := Linha_w ||'Vlr Unit ICMS Op Conv (C186-17)'|| vTab;  -- 022
      Linha_w := Linha_w ||'Vlr Unit ICMS Estoque Conv (C186-13)'|| vTab;  -- 023
      Linha_w := Linha_w ||'Vlr Unit ICMS-ST Estoque Conv (C186-14)'|| vTab;  -- 024
      Linha_w := Linha_w ||'Vlr Unit FCP-ST Estoque Conv (C186-15)'|| vTab;  -- 025


      ESCREVE_ARQ(Linha_w, 6);

       OPEN C_REL_C186_nf_dev_ent;

       LOOP
         FETCH C_REL_C186_nf_dev_ent BULK COLLECT INTO rREL_C186_nf_dev_ent LIMIT 500;
         EXIT WHEN rREL_C186_nf_dev_ent.COUNT = 0;

         FOR I IN rREL_C186_nf_dev_ent.FIRST .. rREL_C186_nf_dev_ent.LAST LOOP

           LINHA_W := rREL_C186_nf_dev_ent(I).COD_EMPRESA  -- 001
                      ||vTab|| rREL_C186_nf_dev_ent(I).COD_ESTAB  -- 002
                      ||vTab|| rREL_C186_nf_dev_ent(I).DATA_FISCAL  -- 003
                      ||vTab|| rREL_C186_nf_dev_ent(I).MOVTO_E_S  -- 004
                      ||vTab|| rREL_C186_nf_dev_ent(I).NORM_DEV  -- 005
                      ||vTab|| rREL_C186_nf_dev_ent(I).COD_DOCTO  -- 006
                      ||vTab|| rREL_C186_nf_dev_ent(I).IND_FIS_JUR || '-' || rREL_C186_nf_dev_ent(I).COD_FIS_JUR  -- 007
                      ||vTab|| rREL_C186_nf_dev_ent(I).NUM_DOCFIS  -- 008
                      ||vTab|| rREL_C186_nf_dev_ent(I).SERIE_DOCFIS  -- 009
                      ||vTab|| rREL_C186_nf_dev_ent(I).SUB_SERIE_DOCFIS  -- 010
                      ||vTab|| rREL_C186_nf_dev_ent(I).IND_PROD_NF_DEV || '-' || rREL_C186_nf_dev_ent(I).COD_PROD_NF_DEV  -- 031
                      ||vTab|| rREL_C186_nf_dev_ent(I).NUM_ITEM  -- 011
                      ||vTab|| rREL_C186_nf_dev_ent(I).NUM_DOCFIS_REF  -- 012
                      ||vTab|| rREL_C186_nf_dev_ent(I).SERIE_DOCFIS_REF  -- 013
                      ||vTab|| rREL_C186_nf_dev_ent(I).SUB_SERIE_DOCFIS_REF  -- 014
                      ||vTab|| rREL_C186_nf_dev_ent(I).COD_DOCTO_REF  -- 015
                      ||vTab|| rREL_C186_nf_dev_ent(I).DATA_FISCAL_REF  -- 016
                      ||vTab|| rREL_C186_nf_dev_ent(I).NUM_ITEM_DOC_REF  -- 017
                      ||vTab|| rREL_C186_nf_dev_ent(I).COD_MOTIVO  -- 018
                      ||vTab|| FormataValor(rREL_C186_nf_dev_ent(I).QTD_CONV, 'N', 17, 6)  -- 019
                      ||vTab|| rREL_C186_nf_dev_ent(I).COD_MEDIDA  -- 020
                      ||vTab|| FormataValor(rREL_C186_nf_dev_ent(I).VLR_UNIT_CONV, 'N', 19, 6)  -- 021
                      ||vTab|| FormataValor(rREL_C186_nf_dev_ent(I).VLR_ICMS_CONV, 'N', 19, 6)  -- 022
                      ||vTab|| FormataValor(rREL_C186_nf_dev_ent(I).vlr_unit_bc_icmss_ent, 'N', 19, 6)  -- 023
                      ||vTab|| FormataValor(rREL_C186_nf_dev_ent(I).VLR_UNIT_ICMSS_CONV_ENT, 'N', 19, 6)  -- 024
                      ||vTab|| FormataValor(rREL_C186_nf_dev_ent(I).VLR_UNIT_FCP_CONV_ENT, 'N', 19, 6)  -- 025
                      ;
                   ESCREVE_ARQ(LINHA_W, 6);

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_REL_C186_nf_dev_ent;

       Lib_proc.add_log('Geração do Relatório C186 realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o Relatorio EST_RESSARC_RS_IN087_Rel.gera_rel_C186_nf_dev_ent.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
        If C_REL_C186_nf_dev_ent%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_REL_C186_nf_dev_ent;
        End If;
   END gera_rel_C186_nf_dev_ent;

PROCEDURE gera_REL_C195 IS
  Cursor C_X112
         (pCodEmp         IN VARCHAR2,
          pCodEstab       IN VARCHAR2,
          pDataIni        IN DATE,
          pDataFim        IN DATE)
  Is (select v.*
           , X04.ind_fis_jur, X04.cod_fis_jur,X2005.cod_docto,X2009.cod_observacao
      from X112_OBS_DOCFIS v
         , X04_PESSOA_FIS_JUR X04
         , X2005_TIPO_DOCTO X2005
         , X2009_OBSERVACAO X2009
      WHERE  v.cod_empresa    = pCodEmp
      AND    v.cod_estab      = pCodEstab
      AND    v.data_fiscal    between  pDataIni and  pDataFim
      AND    V.ident_fis_jur  = X04.ident_fis_jur
      AND    V.ident_docto    = X2005.ident_docto
      AND    V.ident_observacao    = X2009.ident_observacao
      );


  type tX112    is table of C_X112%rowtype;
  rX112 tX112 := tX112();

   BEGIN
      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório C195 =============================================',0);

      Arquivo_w := 'Relatorio_Conferencia_C195_' || to_char(mData_ini, 'MM') || '_' || to_char(mData_ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 4, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Cod Empresa'|| vTab;
      Linha_w := Linha_w ||'Cod Estab'|| vTab;
      Linha_w := Linha_w ||'Dt Fiscal'|| vTab;
      Linha_w := Linha_w ||'E/S NF Devolução'|| vTab;  -- 004
      Linha_w := Linha_w ||'Norm/Dev'|| vTab;  -- 005
      Linha_w := Linha_w ||'Cod Docto'|| vTab;  -- 006
      Linha_w := Linha_w ||'Ind Fis/Jur Cod Fis/Jur'|| vTab;  -- 007
      Linha_w := Linha_w ||'Num Docfis'|| vTab;  -- 008
      Linha_w := Linha_w ||'Serie NF'|| vTab;  -- 009
      Linha_w := Linha_w ||'SubSerie'|| vTab;  -- 010
      Linha_w := Linha_w ||'Codigo de Observacao'|| vTab;
--      Linha_w := Linha_w ||'Imd Comp Lanc'|| vTab;
--      Linha_w := Linha_w ||'Dsc Comp Ajuste'|| vTab;
--      Linha_w := Linha_w ||'Num Proc'|| vTab;
--      Linha_w := Linha_w ||'Ind Grav'|| vTab;
      Linha_w := Linha_w ||'Vinculo'|| vTab;


      ESCREVE_ARQ(Linha_w, 4);


      OPEN C_X112(mCod_Empresa,
                  mCod_Estab,
                  mData_Ini,
                  mData_Fim);

      LOOP
        FETCH C_X112 BULK COLLECT INTO rX112 LIMIT 1000;
        EXIT WHEN rX112.count = 0;
        FOR i IN rX112.FIRST..rX112.LAST
        Loop
           LINHA_W := rX112(i).COD_EMPRESA  -- 001
                      ||vTab|| rX112(i).COD_ESTAB  -- 002
                      ||vTab|| rX112(i).DATA_FISCAL  -- 003
                      ||vTab|| rX112(i).MOVTO_E_S  -- 004
                      ||vTab|| rX112(i).NORM_DEV  -- 005
                      ||vTab|| rX112(i).COD_DOCTO  -- 006
                      ||vTab|| rX112(i).IND_FIS_JUR || '-' || rX112(i).COD_FIS_JUR  -- 007
                      ||vTab|| rX112(i).NUM_DOCFIS  -- 008
                      ||vTab|| rX112(i).SERIE_DOCFIS  -- 009
                      ||vTab|| rX112(i).SUB_SERIE_DOCFIS  -- 010
                      ||vTab|| rX112(i).cod_observacao
--                      ||vTab|| rX112(i).IND_ICOMPL_LANCTO
--                      ||vTab|| rX112(i).dsc_complementar
--                      ||vTab|| rX112(i).num_processo
--                      ||vTab|| rX112(i).ind_gravacao
                      ||vTab|| rX112(i).vinculacao
                      ;
                   ESCREVE_ARQ(LINHA_W, 4);


         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_X112;

       Lib_proc.add_log('Geração do Relatório C195 realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o Relatorio gera_REL_197.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
        If C_X112%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_X112;
        End If;
   END gera_REL_C195;


PROCEDURE gera_REL_C197 IS
  Cursor C_X113
         (pCodEmp         IN VARCHAR2,
          pCodEstab       IN VARCHAR2,
          pDataIni        IN DATE,
          pDataFim        IN DATE)
  Is (select v.*
           , X04.ind_fis_jur, X04.cod_fis_jur,X2005.cod_docto,X2009.cod_observacao
      from X113_AJUSTE_APUR v
         , X04_PESSOA_FIS_JUR X04
         , X2005_TIPO_DOCTO X2005
         , X2009_OBSERVACAO X2009
      WHERE  v.cod_empresa    = pCodEmp
      AND    v.cod_estab      = pCodEstab
      AND    v.data_fiscal    between  pDataIni and  pDataFim
      AND    V.ident_fis_jur  = X04.ident_fis_jur
      AND    V.ident_docto    = X2005.ident_docto
      AND    V.ident_observacao    = X2009.ident_observacao(+)
--      and    v.
      );


  type tX113    is table of C_X113%rowtype;
  rX113 tX113 := tX113();

   BEGIN
      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório C197 =============================================',0);

      Arquivo_w := 'Relatorio_Conferencia_C197_' || to_char(mData_ini, 'MM') || '_' || to_char(mData_ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 3, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Cod Empresa'|| vTab;
      Linha_w := Linha_w ||'Cod Estab'|| vTab;
      Linha_w := Linha_w ||'Data da Escrita Fiscal'|| vTab;
      Linha_w := Linha_w ||'E/S NF'|| vTab;  -- 004
      Linha_w := Linha_w ||'Norm/Dev'|| vTab;  -- 005
      Linha_w := Linha_w ||'Cod Docto'|| vTab;  -- 006
      Linha_w := Linha_w ||'Ind Fis/Jur Cod Fis/Jur'|| vTab;  -- 007
      Linha_w := Linha_w ||'Num Docfis'|| vTab;  -- 008
      Linha_w := Linha_w ||'Serie NF'|| vTab;  -- 009
      Linha_w := Linha_w ||'SubSerie'|| vTab;  -- 010
      Linha_w := Linha_w ||'Código da Observação'|| vTab;
--      Linha_w := Linha_w ||'Imd Comp Lanc'|| vTab;
      Linha_w := Linha_w ||'Código do Ajuste'|| vTab;
--      Linha_w := Linha_w ||'Discr Item'|| vTab;
--      Linha_w := Linha_w ||'Num Item'|| vTab;
--      Linha_w := Linha_w ||'Dsc Comp Ajuste'|| vTab;
--      Linha_w := Linha_w ||'Valor Base ICMS'|| vTab;
--      Linha_w := Linha_w ||'Valor Aliq ICMS'|| vTab;
      Linha_w := Linha_w ||'Valor ICMS'|| vTab;
--      Linha_w := Linha_w ||'Valor Outros'|| vTab;
--      Linha_w := Linha_w ||'Num Proc'|| vTab;
--      Linha_w := Linha_w ||'Ind Grav'|| vTab;


      ESCREVE_ARQ(Linha_w, 3);


      OPEN C_X113(mCod_Empresa,
                  mCod_Estab,
                  mData_Ini,
                  mData_Fim);

      LOOP
        FETCH C_X113 BULK COLLECT INTO rX113 LIMIT 1000;
        EXIT WHEN rX113.count = 0;
        FOR i IN rX113.FIRST..rX113.LAST
        Loop
           LINHA_W := rX113(i).COD_EMPRESA  -- 001
                      ||vTab|| rX113(i).COD_ESTAB  -- 002
                      ||vTab|| rX113(i).DATA_FISCAL  -- 003
                      ||vTab|| rX113(i).MOVTO_E_S  -- 004
                      ||vTab|| rX113(i).NORM_DEV  -- 005
                      ||vTab|| rX113(i).COD_DOCTO  -- 006
                      ||vTab|| rX113(i).IND_FIS_JUR || '-' || rX113(i).COD_FIS_JUR  -- 007
                      ||vTab|| rX113(i).NUM_DOCFIS  -- 008
                      ||vTab|| rX113(i).SERIE_DOCFIS  -- 009
                      ||vTab|| rX113(i).SUB_SERIE_DOCFIS  -- 010
                      ||vTab|| rX113(i).cod_observacao
--                      ||vTab|| rX113(i).IND_ICOMPL_LANCTO
                      ||vTab|| rX113(i).COD_AJUSTE_SPED
--                      ||vTab|| rX113(i).DISCRI_ITEM
--                      ||vTab|| rX113(i).num_item
--                      ||vTab|| rX113(i).dsc_comp_ajuste
--                      ||vTab|| FormataValor(rX113(i).vlr_base_icms, 'N', 17, 2)
--                      ||vTab|| FormataValor(rX113(i).aliquota_icms, 'N', 7, 4)
                      ||vTab|| FormataValor(rX113(i).vlr_icms, 'N', 17, 2)
--                      ||vTab|| FormataValor(rX113(i).vlr_outros, 'N', 17, 2)
--                      ||vTab|| rX113(i).num_processo
--                      ||vTab|| rX113(i).ind_gravacao
                      ;
                   ESCREVE_ARQ(LINHA_W, 3);


         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_X113;

       Lib_proc.add_log('Geração do Relatório C197 realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o Relatorio gera_REL_197.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
        If C_X113%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_X113;
        End If;
   END gera_REL_C197;

PROCEDURE gera_REL_ITEM_APURAC_SUBST IS
CURSOR C_REL_ITEM_APURAC_SUBST Is
Select i.*
From ITEM_APURAC_SUBST i
WHERE  i.COD_EMPRESA     = MCOD_EMPRESA
AND    i.COD_ESTAB       = MCOD_ESTAB
AND    i.DAT_APURACAO    = mData_Fim
AND    i.COD_TIPO_LIVRO    = '108'
Order By I.COD_EMPRESA asc,
         I.COD_ESTAB asc,
         I.DAT_APURACAO asc,
         I.COD_TIPO_LIVRO asc
;
  TYPE tREL_ITEM_APURAC_SUBST        IS TABLE OF C_REL_ITEM_APURAC_SUBST%ROWTYPE INDEX BY BINARY_INTEGER;
  rREL_ITEM_APURAC_SUBST              tREL_ITEM_APURAC_SUBST;

   BEGIN

      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório Lancto_P9_ST =============================================',0);
      Arquivo_w := 'Relatorio_Conferencia_Lancto_P9_ST_' || to_char(mData_ini, 'MM') || '_' || to_char(mData_ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 2, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Codigo da Empresa'|| vTab;
      Linha_w := Linha_w ||'Codigo do Estabelecimento'|| vTab;
      Linha_w := Linha_w ||'Código do Livro'|| vTab;
      Linha_w := Linha_w ||'Data da Apuracao'|| vTab;
--      Linha_w := Linha_w ||'UF'|| vTab;
      --Linha_w := Linha_w ||'Ind Uf'|| vTab;
      Linha_w := Linha_w ||'Operação da Apuração'|| vTab;
      --Linha_w := Linha_w ||'Num Discriminacao'|| vTab;
      Linha_w := Linha_w ||'Valor do Lançamento'|| vTab;
      --Linha_w := Linha_w ||'Ind Tip Deducao'|| vTab;
      Linha_w := Linha_w ||'Descrição do Lançamento'|| vTab;
      --Linha_w := Linha_w ||'Valor Base St'|| vTab;
      --Linha_w := Linha_w ||'Cod Classe'|| vTab;
      --Linha_w := Linha_w ||'Cod Sub Item'|| vTab;
      --Linha_w := Linha_w ||'Ind dig calc'|| vTab;
      --Linha_w := Linha_w ||'Num Proc'|| vTab;
      --Linha_w := Linha_w ||'Orig Proc'|| vTab;
      --Linha_w := Linha_w ||'Dsc Proc'|| vTab;
--      Linha_w := Linha_w ||'Obs'|| vTab;
      --Linha_w := Linha_w ||'Cod Ajuste Icms'|| vTab;
      --Linha_w := Linha_w ||'Ind Tip Lanc'|| vTab;
      --Linha_w := Linha_w ||'cod_ajuste_sef'|| vTab;
      --Linha_w := Linha_w ||'cod_prog_gnre'|| vTab;
      --Linha_w := Linha_w ||'cod_regime_esp'|| vTab;
      --Linha_w := Linha_w ||'cod_Origem'|| vTab;


      ESCREVE_ARQ(Linha_w, 2);

       OPEN C_REL_ITEM_APURAC_SUBST;

       LOOP
         FETCH C_REL_ITEM_APURAC_SUBST BULK COLLECT INTO rREL_ITEM_APURAC_SUBST LIMIT 500;
         EXIT WHEN rREL_ITEM_APURAC_SUBST.COUNT = 0;

         FOR I IN rREL_ITEM_APURAC_SUBST.FIRST .. rREL_ITEM_APURAC_SUBST.LAST LOOP

           LINHA_W := rREL_ITEM_APURAC_SUBST(I).COD_EMPRESA  -- 001
                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).COD_ESTAB  -- 002
                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_tipo_livro  -- 003
                      ||vTab|| TO_CHAR(rREL_ITEM_APURAC_SUBST(I).dat_apuracao)
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).ident_estado
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).ind_uf
                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_oper_apur
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).num_discriminacao
                      ||vTab|| FormataValor(rREL_ITEM_APURAC_SUBST(I).val_item_discrim, 'N', 17, 2)
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).ind_tipo_deducao
                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).dsc_item_apuracao
--                      ||vTab|| FormataValor(rREL_ITEM_APURAC_SUBST(I).vlr_base_st, 'N', 17, 2)
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_classe
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_amparo_legal
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_sub_item_ocorr
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).ind_dig_calculado
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).num_proc
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).origem_proc
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).dsc_proc
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_ajuste
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).dsc_proc
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).ident_observacao
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_ajuste_icms
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).ind_tipo_lanc
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_ajuste_sef
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_prod_gnre
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_regime_especial
--                      ||vTab|| rREL_ITEM_APURAC_SUBST(I).cod_origem
                      ;
                   ESCREVE_ARQ(LINHA_W, 2);


         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_REL_ITEM_APURAC_SUBST;

       Lib_proc.add_log('Geração do Relatório ITEM_APURAC_SUBST realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o Relatorio gera_REL_ITEM_APURAC_SUBST.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
        If C_REL_ITEM_APURAC_SUBST%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_REL_ITEM_APURAC_SUBST;
        End If;
   END gera_REL_ITEM_APURAC_SUBST;

  PROCEDURE gera_rel_media_pond IS
   BEGIN

      Lib_Proc.Add_Log(' ',0);
      Lib_Proc.Add_Log('=================================================Relatório Média Pond.=============================================',0);

      Arquivo_w := 'Relatorio_Conferencia_Calculo_Media_Ponderada_' || to_char(mData_Ini, 'MM') || '_' || to_char(mData_Ini, 'YYYY')|| '_' || mCod_estab || vExt;
      lib_proc.add_tipo(mProc_Id, 1, Arquivo_w, 2);

      -- Cabeçaljo arquivo saida
      Linha_w := 'Cod Empresa'|| vTab;  -- 001
      Linha_w := Linha_w ||'Cod Estab'|| vTab;  -- 002
      Linha_w := Linha_w ||'Dia'|| vTab;  -- 003
      Linha_w := Linha_w ||'Ind Produto (SAFX2013-01) Cod Produto (SAFX2013-02)'|| vTab;  -- 004
      Linha_w := Linha_w ||'Qtde Inicial'|| vTab;  -- 005
      Linha_w := Linha_w ||'Valor ICMS Inicial'|| vTab;  -- 006
      Linha_w := Linha_w ||'Valor ICMS-ST Inicial'|| vTab;  -- 007
      Linha_w := Linha_w ||'Valor Base de Cálculo do ICMS-ST Inicial'|| vTab;  -- 008
      Linha_w := Linha_w ||'Valor FECEP-ST Inicial'|| vTab;  -- 009
      Linha_w := Linha_w ||'Qtde (Entrada)'|| vTab;  -- 015
      Linha_w := Linha_w ||'Valor ICMS (Entrada)'|| vTab;  -- 016
      Linha_w := Linha_w ||'Valor ICMS-ST (Entrada)'|| vTab;  -- 017
      Linha_w := Linha_w ||'Valor Base de Cálculo do ICMS-ST (Entrada)'|| vTab;  -- 018
      Linha_w := Linha_w ||'Valor FECEP-ST (Entrada)'|| vTab;  -- 019
      Linha_w := Linha_w ||'Qtde (Devolução Entrada)'|| vTab;  -- 020
      Linha_w := Linha_w ||'Valor ICMS (Devolução Entrada)'|| vTab;  -- 021
      Linha_w := Linha_w ||'Valor ICMS-ST (Devolução Entrada)'|| vTab;  -- 022
      Linha_w := Linha_w ||'Valor Base de Cálculo do ICMS-ST (Devolução Entrada)'|| vTab;  -- 023
      Linha_w := Linha_w ||'Valor FECEP-ST (Devolução Entrada)'|| vTab;  -- 024
      Linha_w := Linha_w ||'Qtde Final'|| vTab;  -- 025
      Linha_w := Linha_w ||'Valor ICMS Final'|| vTab;  -- 026
      Linha_w := Linha_w ||'Valor ICMS-ST Final'|| vTab;  -- 027
      Linha_w := Linha_w ||'Valor Base de Cálculo do ICMS-ST Final'|| vTab;  -- 028
      Linha_w := Linha_w ||'Valor FECEP-ST Final'|| vTab;  -- 029
      Linha_w := Linha_w ||'Valor Médio Unitário ICMS'|| vTab;  -- 030
      Linha_w := Linha_w ||'Valor Médio Unitário ICMS-ST s/ FECEP'|| vTab;  -- 031
      Linha_w := Linha_w ||'Valor Médio Unitário ICMS-ST c/ FECEP'|| vTab;  -- 032
      Linha_w := Linha_w ||'Valor Médio Unitário Base de Cálculo do ICMS-ST'|| vTab;  -- 033
      Linha_w := Linha_w ||'Valor Médio Unitário  FECEP-ST';  -- 034

      ESCREVE_ARQ(Linha_w, 1);

       OPEN C_REL_MEDIA_POND;

       LOOP
         FETCH C_REL_MEDIA_POND BULK COLLECT INTO rREL_MEDIA_POND LIMIT 500;
         EXIT WHEN rREL_MEDIA_POND.COUNT = 0;

         FOR I IN rREL_MEDIA_POND.FIRST .. rREL_MEDIA_POND.LAST LOOP

           LINHA_W := rREL_MEDIA_POND(I).COD_EMPRESA  -- 001
                      ||vTab|| rREL_MEDIA_POND(I).COD_ESTAB_GER  -- 002
                      ||vTab|| rREL_MEDIA_POND(I).DATA  -- 003
                      ||vTab|| rREL_MEDIA_POND(I).IND_PRODUTO || '-' || rREL_MEDIA_POND(I).COD_PRODUTO  -- 004
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).QTD_CONV_INI, 'N', 17, 6)  -- 005
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_INI_MP, 'N', 19, 6)  -- 006
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_ST_INI_MP, 'N', 19, 6)  -- 007
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_BC_ST_INI_MP, 'N', 19, 6)  -- 008
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_FECEP_ST_INI_MP, 'N', 19, 6)  -- 009
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).QTD_CONV_ENT_MP, 'N', 17, 6)  -- 015
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_ENT_MP, 'N', 19, 6)  -- 016
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_ST_ENT_MP, 'N', 19, 6)  -- 017
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_BC_ST_ENT_MP, 'N', 19, 6)  -- 018
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_FECEP_ST_ENT_MP, 'N', 19, 6)  -- 019
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).QTD_CONV_DEV_ENT_MP, 'N', 17, 6)  -- 020
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_DEV_ENT_MP, 'N', 19, 6)  -- 021
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_ST_DEV_ENT_MP, 'N', 19, 6)  -- 022
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_BC_ST_DEV_ENT_MP, 'N', 19, 6)  -- 023
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_FECEP_ST_DEV_ENT_MP, 'N', 19, 6)  -- 024
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).QTD_CONV_FIM, 'N', 17, 6)  -- 025
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_FIM_MP, 'N', 19, 6)  -- 026
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_ICMS_ST_FIM_MP, 'N', 19, 6)  -- 027
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_BC_ST_FIM_MP, 'N', 19, 6)  -- 028
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_FECEP_ST_FIM_MP, 'N', 19, 6)  -- 029
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_UNIT_ICMS_FIM_MP, 'N', 19, 6)  -- 030
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_UNIT_ICMS_ST_FIM_MP, 'N', 19, 6)  -- 031
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_UNIT_ICMS_ST_FECEP_FIM_MP, 'N', 19, 6)  -- 032
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_UNIT_BC_ST_FIM_MP, 'N', 19, 6)  -- 033
                      ||vTab|| FormataValor(rREL_MEDIA_POND(I).VLR_UNIT_FECEP_ST_FIM_MP, 'N', 19, 6);  -- 034

           ESCREVE_ARQ(LINHA_W, 1);

         END LOOP;

       End Loop; -- Fim da leitura cursor
       CLOSE C_REL_MEDIA_POND;

       Lib_proc.add_log('Geração do Relatório Média Pond. realizada com sucesso. ',0);

   EXCEPTION
      WHEN OTHERS THEN
        Lib_Proc.Add_Log ('Erro ao gerar o Relatorio WMX_SPED_RESSARC_RJ_REL.gera_rel_media_pond.' ||  To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
        If C_REL_MEDIA_POND%ISOPEN Then  -- Verifica se cursor está aberto
         Close C_REL_MEDIA_POND;
        End If;
   END;


  FUNCTION Executar (P_C181 in varchar2,P_C186 in varchar2,P_C195_C197 in varchar2,P_C185 in varchar2 ) RETURN INTEGER IS
  BEGIN

    mcod_empresa  := Pkg_Dados_Param.getCodEmpresa;
    mCod_Estab    := Pkg_Dados_Param.getCodEstab;
    mData_ini     := Pkg_Dados_Param.getDataIni;
    mData_Fim     := Pkg_Dados_Param.getDataFim;
    mProc_Id      := Pkg_Dados_Param.getProcId;
    mDataInv      := Pkg_Dados_Param.getDataDevC186;

--    gera_rel_C180_nf_ent;
--    gera_rel_C185_C380_nf_sai;
--    if nvl(Pkg_Dados_Param.getInd2,'N') = 'S' then
    if nvl(P_C181,'N') = 'S' then
       gera_rel_C181_nf_dev_sai;
    end if;
    if nvl(P_C185,'N') = 'S' then
       gera_rel_C185;
    end if;
--    if nvl(Pkg_Dados_Param.getInd3,'N') = 'S' then
    if nvl(P_C186,'N') = 'S' then
       gera_rel_C186_nf_dev_ent;
    end if;
    gera_rel_media_pond;

    if nvl(P_C195_C197,'N') = 'S' then

      gera_rel_C195;
      gera_rel_C197;
      gera_REL_ITEM_APURAC_SUBST;
    end if;
    
    --meio magnético
    --gera_MM;

    COMMIT;
    RETURN mProc_Id;

   EXCEPTION
     WHEN OTHERS THEN
       Lib_Proc.Add_Log ('Erro ao gerar o Relatorio.' || To_Char(SQLCODE) || ' - ' || SQLERRM, 0);
       RETURN -1;
   END;

END WMX_SPED_RESSARC_RJ_REL;
/
