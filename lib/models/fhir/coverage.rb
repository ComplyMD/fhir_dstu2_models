# Copyright (c) 2011-2015, HL7, Inc & The MITRE Corporation
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification, 
# are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice, this 
#       list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright notice, 
#       this list of conditions and the following disclaimer in the documentation 
#       and/or other materials provided with the distribution.
#     * Neither the name of HL7 nor the names of its contributors may be used to 
#       endorse or promote products derived from this software without specific 
#       prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT 
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
# POSSIBILITY OF SUCH DAMAGE.

module FHIR
    class Coverage 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Coverage
        
        SEARCH_PARAMS = [
            'identifier',
            'sequence',
            'subplan',
            'type',
            'plan',
            'dependent',
            'issuer',
            'group'
        ]
        
        VALID_CODES = {
            fhirType: [ '_ActAccountCode', 'ACCTRECEIVABLE', 'CASH', 'CC', 'AE', 'DN', 'DV', 'MC', 'V', 'PBILLACCT', '_ActAdjudicationCode', '_ActAdjudicationGroupCode', 'CONT', 'DAY', 'LOC', 'MONTH', 'PERIOD', 'PROV', 'WEEK', 'YEAR', 'AA', 'ANF', 'AR', 'AS', '_ActAdjudicationResultActionCode', 'DISPLAY', 'FORM', '_ActBillableModifierCode', 'CPTM', 'HCPCSA', '_ActBillingArrangementCode', 'BLK', 'CAP', 'CONTF', 'FINBILL', 'ROST', 'SESS', '_ActBoundedROICode', 'ROIFS', 'ROIPS', '_ActCareProvisionCode', '_ActCredentialedCareCode', '_ActCredentialedCareProvisionPersonCode', 'CACC', 'CAIC', 'CAMC', 'CANC', 'CAPC', 'CBGC', 'CCCC', 'CCGC', 'CCPC', 'CCSC', 'CDEC', 'CDRC', 'CEMC', 'CFPC', 'CIMC', 'CMGC', 'CNEC', 'CNMC', 'CNQC', 'CNSC', 'COGC', 'COMC', 'COPC', 'COSC', 'COTC', 'CPEC', 'CPGC', 'CPHC', 'CPRC', 'CPSC', 'CPYC', 'CROC', 'CRPC', 'CSUC', 'CTSC', 'CURC', 'CVSC', 'LGPC', '_ActCredentialedCareProvisionProgramCode', 'AALC', 'AAMC', 'ABHC', 'ACAC', 'ACHC', 'AHOC', 'ALTC', 'AOSC', 'CACS', 'CAMI', 'CAST', 'CBAR', 'CCAD', 'CCAR', 'CDEP', 'CDGD', 'CDIA', 'CEPI', 'CFEL', 'CHFC', 'CHRO', 'CHYP', 'CMIH', 'CMSC', 'COJR', 'CONC', 'COPD', 'CORT', 'CPAD', 'CPND', 'CPST', 'CSDM', 'CSIC', 'CSLD', 'CSPT', 'CTBU', 'CVDC', 'CWMA', 'CWOH', '_ActEncounterCode', 'AMB', 'EMER', 'FLD', 'HH', 'IMP', 'ACUTE', 'NONAC', 'PRENC', 'SS', 'VR', '_ActMedicalServiceCode', 'ALC', 'CARD', 'CHR', 'DNTL', 'DRGRHB', 'GENRL', 'MED', 'OBS', 'ONC', 'PALL', 'PED', 'PHAR', 'PHYRHB', 'PSYCH', 'SURG', '_ActClaimAttachmentCategoryCode', 'AUTOATTCH', 'DOCUMENT', 'HEALTHREC', 'IMG', 'LABRESULTS', 'MODEL', 'WIATTCH', 'XRAY', '_ActConsentType', 'ICOL', 'IDSCL', 'INFA', 'INFAO', 'INFASO', 'IRDSCL', 'RESEARCH', 'RSDID', 'RSREID', '_ActContainerRegistrationCode', 'ID', 'IP', 'L', 'M', 'O', 'R', 'X', '_ActControlVariable', 'AUTO', 'ENDC', 'REFLEX', '_ActCoverageConfirmationCode', '_ActCoverageAuthorizationConfirmationCode', 'AUTH', 'NAUTH', '_ActCoverageLimitCode', '_ActCoverageQuantityLimitCode', 'COVPRD', 'LFEMX', 'NETAMT', 'PRDMX', 'UNITPRICE', 'UNITQTY', 'COVMX', '_ActCoverageTypeCode', '_ActInsurancePolicyCode', 'EHCPOL', 'HSAPOL', 'AUTOPOL', 'COL', 'UNINSMOT', 'PUBLICPOL', 'DENTPRG', 'DISEASEPRG', 'CANPRG', 'ENDRENAL', 'HIVAIDS', 'MANDPOL', 'MENTPRG', 'SAFNET', 'SUBPRG', 'SUBSIDIZ', 'SUBSIDMC', 'SUBSUPP', 'WCBPOL', '_ActInsuranceTypeCode', '_ActHealthInsuranceTypeCode', 'DENTAL', 'DISEASE', 'DRUGPOL', 'HIP', 'LTC', 'MCPOL', 'POS', 'HMO', 'PPO', 'MENTPOL', 'SUBPOL', 'VISPOL', 'DIS', 'EWB', 'FLEXP', 'LIFE', 'ANNU', 'TLIFE', 'ULIFE', 'PNC', 'REI', 'SURPL', 'UMBRL', '_ActProgramTypeCode', 'CHAR', 'CRIME', 'EAP', 'GOVEMP', 'HIRISK', 'IND', 'MILITARY', 'RETIRE', 'SOCIAL', 'VET', '_ActDetectedIssueManagementCode', '_ActAdministrativeDetectedIssueManagementCode', '_AuthorizationIssueManagementCode', 'EMAUTH', '21', '1', '19', '2', '22', '23', '3', '4', '5', '6', '7', '14', '15', '16', '17', '18', '20', '8', '10', '11', '12', '13', '9', '_ActExposureCode', 'CHLDCARE', 'CONVEYNC', 'HLTHCARE', 'HOMECARE', 'HOSPPTNT', 'HOSPVSTR', 'HOUSEHLD', 'INMATE', 'INTIMATE', 'LTRMCARE', 'PLACE', 'PTNTCARE', 'SCHOOL2', 'SOCIAL2', 'SUBSTNCE', 'TRAVINT', 'WORK2', '_ActFinancialTransactionCode', 'CHRG', 'REV', '_ActIncidentCode', 'MVA', 'SCHOOL', 'SPT', 'WPA', '_ActInformationAccessCode', 'ACADR', 'ACALL', 'ACALLG', 'ACCONS', 'ACDEMO', 'ACDI', 'ACIMMUN', 'ACLAB', 'ACMED', 'ACMEDC', 'ACMEN', 'ACOBS', 'ACPOLPRG', 'ACPROV', 'ACPSERV', 'ACSUBSTAB', '_ActInformationAccessContextCode', 'INFAUT', 'INFCON', 'INFCRT', 'INFDNG', 'INFEMER', 'INFPWR', 'INFREG', '_ActInformationCategoryCode', 'ALLCAT', 'ALLGCAT', 'ARCAT', 'COBSCAT', 'DEMOCAT', 'DICAT', 'IMMUCAT', 'LABCAT', 'MEDCCAT', 'MENCAT', 'PSVCCAT', 'RXCAT', '_ActInvoiceElementCode', '_ActInvoiceAdjudicationPaymentCode', '_ActInvoiceAdjudicationPaymentGroupCode', 'ALEC', 'BONUS', 'CFWD', 'EDU', 'EPYMT', 'GARN', 'INVOICE', 'PINV', 'PPRD', 'PROA', 'RECOV', 'RETRO', 'TRAN', '_ActInvoiceAdjudicationPaymentSummaryCode', 'INVTYPE', 'PAYEE', 'PAYOR', 'SENDAPP', '_ActInvoiceDetailCode', '_ActInvoiceDetailClinicalProductCode', 'UNSPSC', '_ActInvoiceDetailDrugProductCode', 'GTIN', 'UPC', '_ActInvoiceDetailGenericCode', '_ActInvoiceDetailGenericAdjudicatorCode', 'COIN', 'COPAYMENT', 'DEDUCTIBLE', 'PAY', 'SPEND', '_ActInvoiceDetailGenericModifierCode', 'AFTHRS', 'ISOL', 'OOO', '_ActInvoiceDetailGenericProviderCode', 'CANCAPT', 'DSC', 'ESA', 'FFSTOP', 'FNLFEE', 'FRSTFEE', 'MARKUP', 'MISSAPT', 'PERFEE', 'PERMBNS', 'RESTOCK', 'TRAVEL', 'URGENT', '_ActInvoiceDetailTaxCode', 'FST', 'HST', 'PST', '_ActInvoiceDetailPreferredAccommodationCode', '_ActEncounterAccommodationCode', '_HL7AccommodationCode', 'I', 'P', 'S', 'SP', 'W', '_ActInvoiceGroupCode', '_ActInvoiceInterGroupCode', 'CPNDDRGING', 'CPNDINDING', 'CPNDSUPING', 'DRUGING', 'FRAMEING', 'LENSING', 'PRDING', '_ActInvoiceRootGroupCode', 'CPINV', 'CSINV', 'CSPINV', 'FININV', 'OHSINV', 'PAINV', 'RXCINV', 'RXDINV', 'SBFINV', 'VRXINV', '_ActInvoiceElementSummaryCode', '_InvoiceElementAdjudicated', 'ADNFPPELAT', 'ADNFPPELCT', 'ADNFPPMNAT', 'ADNFPPMNCT', 'ADNFSPELAT', 'ADNFSPELCT', 'ADNFSPMNAT', 'ADNFSPMNCT', 'ADNPPPELAT', 'ADNPPPELCT', 'ADNPPPMNAT', 'ADNPPPMNCT', 'ADNPSPELAT', 'ADNPSPELCT', 'ADNPSPMNAT', 'ADNPSPMNCT', 'ADPPPPELAT', 'ADPPPPELCT', 'ADPPPPMNAT', 'ADPPPPMNCT', 'ADPPSPELAT', 'ADPPSPELCT', 'ADPPSPMNAT', 'ADPPSPMNCT', 'ADRFPPELAT', 'ADRFPPELCT', 'ADRFPPMNAT', 'ADRFPPMNCT', 'ADRFSPELAT', 'ADRFSPELCT', 'ADRFSPMNAT', 'ADRFSPMNCT', '_InvoiceElementPaid', 'PDNFPPELAT', 'PDNFPPELCT', 'PDNFPPMNAT', 'PDNFPPMNCT', 'PDNFSPELAT', 'PDNFSPELCT', 'PDNFSPMNAT', 'PDNFSPMNCT', 'PDNPPPELAT', 'PDNPPPELCT', 'PDNPPPMNAT', 'PDNPPPMNCT', 'PDNPSPELAT', 'PDNPSPELCT', 'PDNPSPMNAT', 'PDNPSPMNCT', 'PDPPPPELAT', 'PDPPPPELCT', 'PDPPPPMNAT', 'PDPPPPMNCT', 'PDPPSPELAT', 'PDPPSPELCT', 'PDPPSPMNAT', 'PDPPSPMNCT', '_InvoiceElementSubmitted', 'SBBLELAT', 'SBBLELCT', 'SBNFELAT', 'SBNFELCT', 'SBPDELAT', 'SBPDELCT', '_ActInvoiceOverrideCode', 'COVGE', 'EFORM', 'FAX', 'GFTH', 'LATE', 'MANUAL', 'OOJ', 'ORTHO', 'PAPER', 'PIE', 'PYRDELAY', 'REFNR', 'REPSERV', 'UNRELAT', 'VERBAUTH', '_ActListCode', '_ActObservationList', 'CARELIST', 'CONDLIST', 'INTOLIST', 'PROBLIST', 'RISKLIST', 'GOALLIST', '_ActTherapyDurationWorkingListCode', '_ActMedicationTherapyDurationWorkingListCode', 'ACU', 'CHRON', 'ONET', 'PRN', 'MEDLIST', 'CURMEDLIST', 'DISCMEDLIST', 'HISTMEDLIST', '_ActMonitoringProtocolCode', 'CTLSUB', 'INV', 'LU', 'OTC', 'RX', 'SA', 'SAC', '_ActNonObservationIndicationCode', 'IND01', 'IND02', 'IND03', 'IND04', 'IND05', '_ActObservationVerificationType', 'VFPAPER', '_ActPaymentCode', 'ACH', 'CHK', 'DDP', 'NON', '_ActPharmacySupplyType', 'DF', 'EM', 'SO', 'FF', 'FFC', 'FFCS', 'FFP', 'FFPS', 'FFSS', 'TFS', 'TF', 'FS', 'MS', 'RF', 'UD', 'RFC', 'RFCS', 'RFF', 'RFFS', 'RFP', 'RFPS', 'RFS', 'TB', 'TBS', 'UDE', '_ActPolicyType', '_ActPrivacyPolicy', '_ActConsentDirective', 'EMRGONLY', 'NOPP', 'OPTIN', 'OPTOUT', '_InformationSensitivityPolicy', '_ActInformationSensitivityPolicy', 'ETH', 'GDIS', 'HIV', 'PSY', 'SCA', 'SDV', 'SEX', 'STD', 'TBOO', '_EntitySensitivityPolicyType', 'DEMO', 'DOB', 'GENDER', 'LIVARG', 'MARST', 'RACE', 'REL', '_RoleInformationSensitivityPolicy', 'B', 'EMPL', 'LOCIS', 'SSP', 'ADOL', 'CEL', 'DIA', 'DRGIS', 'EMP', 'PDS', 'PRS', 'COMPT', 'HRCOMPT', 'RESCOMPT', 'RMGTCOMPT', 'ActTrustPolicyType', 'TRSTACCRD', 'TRSTAGRE', 'TRSTASSUR', 'TRSTCERT', 'TRSTFWK', 'TRSTMEC', 'COVPOL', 'SecurityPolicy', 'ObligationPolicy', 'ANONY', 'AOD', 'AUDIT', 'AUDTR', 'CPLYCC', 'CPLYCD', 'CPLYJPP', 'CPLYOPP', 'CPLYOSP', 'CPLYPOL', 'DEID', 'DELAU', 'ENCRYPT', 'ENCRYPTR', 'ENCRYPTT', 'ENCRYPTU', 'HUAPRV', 'MASK', 'MINEC', 'PRIVMARK', 'PSEUD', 'REDACT', 'RefrainPolicy', 'NOAUTH', 'NOCOLLECT', 'NODSCLCD', 'NODSCLCDS', 'NOINTEGRATE', 'NOLIST', 'NOMOU', 'NOORGPOL', 'NOPAT', 'NOPERSISTP', 'NORDSCLCD', 'NORDSCLCDS', 'NORDSCLW', 'NORELINK', 'NOREUSE', 'NOVIP', 'ORCON', '_ActProductAcquisitionCode', 'LOAN', 'RENT', 'TRANSFER', 'SALE', '_ActSpecimenTransportCode', 'SREC', 'SSTOR', 'STRAN', '_ActSpecimenTreatmentCode', 'ACID', 'ALK', 'DEFB', 'FILT', 'LDLP', 'NEUT', 'RECA', 'UFIL', '_ActSubstanceAdministrationCode', 'DRUG', 'FD', 'IMMUNIZ', '_ActTaskCode', 'OE', 'LABOE', 'MEDOE', 'PATDOC', 'ALLERLREV', 'CLINNOTEE', 'DIAGLISTE', 'DISCHINSTE', 'DISCHSUME', 'PATEDUE', 'PATREPE', 'PROBLISTE', 'RADREPE', 'IMMLREV', 'REMLREV', 'WELLREMLREV', 'PATINFO', 'ALLERLE', 'CDSREV', 'CLINNOTEREV', 'DISCHSUMREV', 'DIAGLISTREV', 'IMMLE', 'LABRREV', 'MICRORREV', 'MICROORGRREV', 'MICROSENSRREV', 'MLREV', 'MARWLREV', 'OREV', 'PATREPREV', 'PROBLISTREV', 'RADREPREV', 'REMLE', 'WELLREMLE', 'RISKASSESS', 'FALLRISK', '_ActTransportationModeCode', '_ActPatientTransportationModeCode', 'AFOOT', 'AMBT', 'AMBAIR', 'AMBGRND', 'AMBHELO', 'LAWENF', 'PRVTRN', 'PUBTRN', '_ObservationType', '_ActSpecObsCode', 'ARTBLD', 'DILUTION', 'AUTO-HIGH', 'AUTO-LOW', 'PRE', 'RERUN', 'EVNFCTS', 'INTFR', 'FIBRIN', 'HEMOLYSIS', 'ICTERUS', 'LIPEMIA', 'VOLUME', 'AVAILABLE', 'CONSUMPTION', 'CURRENT', 'INITIAL', '_AnnotationType', '_ActPatientAnnotationType', 'ANNDI', 'ANNGEN', 'ANNIMM', 'ANNLAB', 'ANNMED', '_GeneticObservationType', 'GENE', '_ImmunizationObservationType', 'OBSANTC', 'OBSANTV', '_IndividualCaseSafetyReportType', 'PAT_ADV_EVNT', 'VAC_PROBLEM', '_LOINCObservationActContextAgeType', '21611-9', '21612-7', '29553-5', '30525-0', '30972-4', '_MedicationObservationType', 'REP_HALF_LIFE', 'SPLCOATING', 'SPLCOLOR', 'SPLIMAGE', 'SPLIMPRINT', 'SPLSCORING', 'SPLSHAPE', 'SPLSIZE', 'SPLSYMBOL', '_ObservationIssueTriggerCodedObservationType', '_CaseTransmissionMode', 'AIRTRNS', 'ANANTRNS', 'ANHUMTRNS', 'BDYFLDTRNS', 'BLDTRNS', 'DERMTRNS', 'ENVTRNS', 'FECTRNS', 'FOMTRNS', 'FOODTRNS', 'HUMHUMTRNS', 'INDTRNS', 'LACTTRNS', 'NOSTRNS', 'PARTRNS', 'PLACTRNS', 'SEXTRNS', 'TRNSFTRNS', 'VECTRNS', 'WATTRNS', '_ObservationQualityMeasureAttribute', 'AGGREGATE', 'COPY', 'CRS', 'DEF', 'DISC', 'FINALDT', 'GUIDE', 'IDUR', 'ITMCNT', 'KEY', 'MEDT', 'MSD', 'MSRADJ', 'MSRAGG', 'MSRIMPROV', 'MSRJUR', 'MSRRPTR', 'MSRRPTTIME', 'MSRSCORE', 'MSRSET', 'MSRTOPIC', 'MSRTP', 'MSRTYPE', 'RAT', 'REF', 'SDE', 'STRAT', 'TRANF', 'USE', '_ObservationSequenceType', 'TIME_ABSOLUTE', 'TIME_RELATIVE', '_ObservationSeriesType', '_ECGObservationSeriesType', 'REPRESENTATIVE_BEAT', 'RHYTHM', '_PatientImmunizationRelatedObservationType', 'CLSSRM', 'GRADE', 'SCHL', 'SCHLDIV', 'TEACHER', '_PopulationInclusionObservationType', 'DENEX', 'DENEXCEP', 'DENOM', 'IPOP', 'IPPOP', 'MSRPOPL', 'MSRPOPLEX', 'NUMER', 'NUMEX', '_PreferenceObservationType', 'PREFSTRENGTH', 'ADVERSE_REACTION', 'ASSERTION', 'CASESER', 'CDIO', 'CRIT', 'CTMO', 'DX', 'ADMDX', 'DISDX', 'INTDX', 'NOI', 'GISTIER', 'HHOBS', 'ISSUE', '_ActAdministrativeDetectedIssueCode', '_ActAdministrativeAuthorizationDetectedIssueCode', 'NAT', 'SUPPRESSED', 'VALIDAT', 'KEY204', 'KEY205', 'COMPLY', 'DUPTHPY', 'DUPTHPCLS', 'DUPTHPGEN', 'ABUSE', 'FRAUD', 'PLYDOC', 'PLYPHRM', 'DOSE', 'DOSECOND', 'DOSEDUR', 'DOSEDURH', 'DOSEDURHIND', 'DOSEDURL', 'DOSEDURLIND', 'DOSEH', 'DOSEHINDA', 'DOSEHIND', 'DOSEHINDSA', 'DOSEHINDW', 'DOSEIVL', 'DOSEIVLIND', 'DOSEL', 'DOSELINDA', 'DOSELIND', 'DOSELINDSA', 'DOSELINDW', 'MDOSE', 'OBSA', 'AGE', 'ADALRT', 'GEALRT', 'PEALRT', 'COND', 'HGHT', 'LACT', 'PREG', 'WGHT', 'CREACT', 'GEN', 'GEND', 'LAB', 'REACT', 'ALGY', 'INT', 'RREACT', 'RALG', 'RAR', 'RINT', 'BUS', 'CODE_INVAL', 'CODE_DEPREC', 'FORMAT', 'ILLEGAL', 'LEN_RANGE', 'LEN_LONG', 'LEN_SHORT', 'MISSCOND', 'MISSMAND', 'NODUPS', 'NOPERSIST', 'REP_RANGE', 'MAXOCCURS', 'MINOCCURS', '_ActAdministrativeRuleDetectedIssueCode', 'KEY206', 'OBSOLETE', '_ActSuppliedItemDetectedIssueCode', '_AdministrationDetectedIssueCode', '_AppropriatenessDetectedIssueCode', '_InteractionDetectedIssueCode', 'FOOD', 'TPROD', 'DRG', 'NHP', 'NONRX', 'PREVINEF', 'DACT', 'TIME', 'ALRTENDLATE', 'ALRTSTRTLATE', '_SupplyDetectedIssueCode', 'ALLDONE', 'FULFIL', 'NOTACTN', 'NOTEQUIV', 'NOTEQUIVGEN', 'NOTEQUIVTHER', 'TIMING', 'INTERVAL', 'MINFREQ', 'HELD', 'TOOLATE', 'TOOSOON', 'HISTORIC', 'PATPREF', 'PATPREFALT', 'KSUBJ', 'KSUBT', 'OINT', 'ALG', 'DALG', 'EALG', 'FALG', 'DINT', 'DNAINT', 'EINT', 'ENAINT', 'FINT', 'FNAINT', 'NAINT', 'SEV', '_ROIOverlayShape', 'CIRCLE', 'ELLIPSE', 'POINT', 'POLY', 'C', 'DIET', 'BR', 'DM', 'FAST', 'FORMULA', 'GF', 'LF', 'LP', 'LQ', 'LS', 'N', 'NF', 'PAF', 'PAR', 'RD', 'SCH', 'SUPPLEMENT', 'T', 'VLI', 'DRUGPRG', 'F', 'PRLMN', 'SECOBS', 'SECCATOBS', 'SECCLASSOBS', 'SECCONOBS', 'SECINTOBS', 'SECALTINTOBS', 'SECDATINTOBS', 'SECINTCONOBS', 'SECINTPRVOBS', 'SECINTPRVABOBS', 'SECINTPRVRBOBS', 'SECINTSTOBS', 'SECTRSTOBS', 'TRSTACCRDOBS', 'TRSTAGREOBS', 'TRSTCERTOBS', 'TRSTFWKOBS', 'TRSTLOAOBS', 'TRSTMECOBS', 'SUBSIDFFS', 'WRKCOMP', '_ActCoverageTypeCode', '_ActInsurancePolicyCode', 'EHCPOL', 'HSAPOL', 'AUTOPOL', 'COL', 'UNINSMOT', 'PUBLICPOL', 'DENTPRG', 'DISEASEPRG', 'CANPRG', 'ENDRENAL', 'HIVAIDS', 'MANDPOL', 'MENTPRG', 'SAFNET', 'SUBPRG', 'SUBSIDIZ', 'SUBSIDMC', 'SUBSUPP', 'WCBPOL', '_ActInsuranceTypeCode', '_ActHealthInsuranceTypeCode', 'DENTAL', 'DISEASE', 'DRUGPOL', 'HIP', 'LTC', 'MCPOL', 'POS', 'HMO', 'PPO', 'MENTPOL', 'SUBPOL', 'VISPOL', 'DIS', 'EWB', 'FLEXP', 'LIFE', 'ANNU', 'TLIFE', 'ULIFE', 'PNC', 'REI', 'SURPL', 'UMBRL', '_ActProgramTypeCode', 'CHAR', 'CRIME', 'EAP', 'GOVEMP', 'HIRISK', 'IND', 'MILITARY', 'RETIRE', 'SOCIAL', 'VET' ]
        }
        
        embeds_one :issuer, class_name:'FHIR::Reference'
        embeds_one :bin, class_name:'FHIR::Identifier'
        embeds_one :period, class_name:'FHIR::Period'
        embeds_one :fhirType, class_name:'FHIR::Coding'
        embeds_one :subscriberId, class_name:'FHIR::Identifier'
        embeds_many :identifier, class_name:'FHIR::Identifier'
        field :group, type: String
        field :plan, type: String
        field :subPlan, type: String
        field :dependent, type: Integer
        field :sequence, type: Integer
        embeds_one :subscriber, class_name:'FHIR::Reference'
        embeds_one :network, class_name:'FHIR::Identifier'
        embeds_many :contract, class_name:'FHIR::Reference'
        track_history
    end
end
