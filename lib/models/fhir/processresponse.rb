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
    class ProcessResponse 
        
        include Mongoid::Document
        include Mongoid::History::Trackable
        include FHIR::Element
        include FHIR::Resource
        include FHIR::Formats::Utilities
        include FHIR::Serializer::Utilities
        extend FHIR::Deserializer::ProcessResponse
        
        SEARCH_PARAMS = [
            'identifier',
            'request',
            'organization',
            'requestprovider',
            'requestorganization'
            ]
        # This is an ugly hack to deal with embedded structures in the spec notes
        class ProcessResponseNotesComponent
        include Mongoid::Document
        include FHIR::Element
        include FHIR::Formats::Utilities
            
            VALID_CODES = {
                fhirType: [ "display", "print", "printoper" ]
            }
            
            embeds_one :fhirType, class_name:'FHIR::Coding'
            field :text, type: String
        end
        
        embeds_many :identifier, class_name:'FHIR::Identifier'
        embeds_one :request, class_name:'FHIR::Reference'
        embeds_one :outcome, class_name:'FHIR::Coding'
        field :disposition, type: String
        embeds_one :ruleset, class_name:'FHIR::Coding'
        embeds_one :originalRuleset, class_name:'FHIR::Coding'
        field :created, type: FHIR::PartialDateTime
        embeds_one :organization, class_name:'FHIR::Reference'
        embeds_one :requestProvider, class_name:'FHIR::Reference'
        embeds_one :requestOrganization, class_name:'FHIR::Reference'
        embeds_one :form, class_name:'FHIR::Coding'
        embeds_many :notes, class_name:'FHIR::ProcessResponse::ProcessResponseNotesComponent'
        embeds_many :error, class_name:'FHIR::Coding'
        track_history
    end
end
