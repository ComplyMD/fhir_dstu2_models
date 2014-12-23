# Copyright (c) 2011-2014, HL7, Inc & The MITRE Corporation
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
    class OperationDefinition 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::OperationDefinition
        
        SEARCH_PARAMS = [
            'status',
            'code',
            'date',
            'type',
            'kind',
            'version',
            'publisher',
            'title',
            'system',
            'name',
            'base',
            'instance',
            'identifier',
            'profile'
            ]
        
        VALID_CODES = {
            status: [ "draft", "active", "retired" ],
            kind: [ "operation", "query" ],
            fhirType: [ "Alert", "AllergyIntolerance", "Appointment", "AppointmentResponse", "Basic", "Binary", "Bundle", "CarePlan", "CarePlan2", "ClaimResponse", "ClinicalAssessment", "Communication", "CommunicationRequest", "Composition", "ConceptMap", "Condition", "Conformance", "Contract", "Contraindication", "Coverage", "DataElement", "Device", "DeviceComponent", "DeviceMetric", "DeviceUseRequest", "DeviceUseStatement", "DiagnosticOrder", "DiagnosticReport", "DocumentManifest", "DocumentReference", "EligibilityRequest", "EligibilityResponse", "Encounter", "EnrollmentRequest", "EnrollmentResponse", "EpisodeOfCare", "ExplanationOfBenefit", "ExtensionDefinition", "FamilyHistory", "Goal", "Group", "HealthcareService", "ImagingObjectSelection", "ImagingStudy", "Immunization", "ImmunizationRecommendation", "InstitutionalClaim", "List", "Location", "Media", "Medication", "MedicationAdministration", "MedicationDispense", "MedicationPrescription", "MedicationStatement", "MessageHeader", "NamingSystem", "NutritionOrder", "Observation", "OperationDefinition", "OperationOutcome", "OralHealthClaim", "Order", "OrderResponse", "Organization", "Other", "Patient", "PaymentNotice", "PaymentReconciliation", "PendedRequest", "Person", "PharmacyClaim", "Practitioner", "Procedure", "ProcedureRequest", "ProfessionalClaim", "Profile", "Provenance", "Questionnaire", "QuestionnaireAnswers", "Readjudicate", "ReferralRequest", "RelatedPerson", "Reversal", "RiskAssessment", "Schedule", "SearchParameter", "SecurityEvent", "Slot", "Specimen", "StatusRequest", "StatusResponse", "Subscription", "Substance", "Supply", "SupportingDocumentation", "ValueSet", "VisionClaim", "VisionPrescription" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec part
        class OperationDefinitionParameterPartComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            field :name, type: String
            validates_presence_of :name
            field :min, type: Integer
            validates_presence_of :min
            field :max, type: String
            validates_presence_of :max
            field :documentation, type: String
            field :fhirType, type: String
            validates_presence_of :fhirType
            embeds_one :profile, class_name:'FHIR::Reference'
        end
        
        # This is an ugly hack to deal with embedded structures in the spec parameter
        class OperationDefinitionParameterComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                use: [ "in", "out" ]
            }
            
            field :name, type: String
            validates_presence_of :name
            field :use, type: String
            validates :use, :inclusion => { in: VALID_CODES[:use] }
            validates_presence_of :use
            field :min, type: Integer
            validates_presence_of :min
            field :max, type: String
            validates_presence_of :max
            field :documentation, type: String
            field :fhirType, type: String
            embeds_one :profile, class_name:'FHIR::Reference'
            embeds_many :part, class_name:'FHIR::OperationDefinition::OperationDefinitionParameterPartComponent'
        end
        
        field :identifier, type: String
        field :versionNum, type: String
        field :title, type: String
        validates_presence_of :title
        field :publisher, type: String
        embeds_many :telecom, class_name:'FHIR::ContactPoint'
        field :description, type: String
        embeds_many :code, class_name:'FHIR::Coding'
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        field :experimental, type: Boolean
        field :date, type: FHIR::PartialDateTime
        field :kind, type: String
        validates :kind, :inclusion => { in: VALID_CODES[:kind] }
        validates_presence_of :kind
        field :name, type: String
        validates_presence_of :name
        field :notes, type: String
        embeds_one :base, class_name:'FHIR::Reference'
        field :system, type: Boolean
        validates_presence_of :system
        field :fhirType, type: Array # Array of Strings
        validates :fhirType, :inclusion => { in: VALID_CODES[:fhirType], :allow_nil => true }
        field :instance, type: Boolean
        validates_presence_of :instance
        embeds_many :parameter, class_name:'FHIR::OperationDefinition::OperationDefinitionParameterComponent'
        track_history
    end
end