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
    class Appointment 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::Appointment
        
        SEARCH_PARAMS = [
            'partstatus',
            'patient',
            'status',
            'actor',
            'date'
            ]
        
        VALID_CODES = {
            status: [ "pending", "booked", "arrived", "fulfilled", "cancelled", "noshow" ]
        }
        
        # This is an ugly hack to deal with embedded structures in the spec participant
        class AppointmentParticipantComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                status: [ "accepted", "declined", "tentative", "in-process", "completed", "needs-action" ],
                required: [ "required", "optional", "information-only" ]
            }
            
            embeds_many :fhirType, class_name:'FHIR::CodeableConcept'
            embeds_one :actor, class_name:'FHIR::Reference'
            field :required, type: String
            validates :required, :inclusion => { in: VALID_CODES[:required], :allow_nil => true }
            field :status, type: String
            validates :status, :inclusion => { in: VALID_CODES[:status] }
            validates_presence_of :status
        end
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        field :priority, type: Integer
        field :status, type: String
        validates :status, :inclusion => { in: VALID_CODES[:status] }
        validates_presence_of :status
        embeds_one :fhirType, class_name:'FHIR::CodeableConcept'
        embeds_one :reason, class_name:'FHIR::CodeableConcept'
        field :description, type: String
        field :start, type: DateTime
        validates_presence_of :start
        field :end, type: DateTime
        validates_presence_of :end
        embeds_many :slot, class_name:'FHIR::Reference'
        embeds_one :location, class_name:'FHIR::Reference'
        field :comment, type: String
        embeds_one :order, class_name:'FHIR::Reference'
        embeds_many :participant, class_name:'FHIR::Appointment::AppointmentParticipantComponent'
        validates_presence_of :participant
        embeds_one :lastModifiedBy, class_name:'FHIR::Reference'
        field :lastModified, type: FHIR::PartialDateTime
        track_history
    end
end