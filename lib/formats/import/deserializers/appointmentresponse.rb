module FHIR
    module Deserializer
        module AppointmentResponse
        include FHIR::Formats::Utilities
        include FHIR::Deserializer::Utilities
            def parse_xml_entry(entry) 
                return nil unless entry
                model = self.new
                self.parse_element_data(model, entry)
                self.parse_resource_data(model, entry)
                set_model_data(model, 'identifier', entry.xpath('./fhir:identifier').map {|e| FHIR::Identifier.parse_xml_entry(e)})
                set_model_data(model, 'appointment', FHIR::Reference.parse_xml_entry(entry.at_xpath('./fhir:appointment')))
                set_model_data(model, 'participantType', entry.xpath('./fhir:participantType').map {|e| FHIR::CodeableConcept.parse_xml_entry(e)})
                set_model_data(model, 'actor', FHIR::Reference.parse_xml_entry(entry.at_xpath('./fhir:actor')))
                set_model_data(model, 'participantStatus', entry.at_xpath('./fhir:participantStatus/@value').try(:value))
                set_model_data(model, 'comment', entry.at_xpath('./fhir:comment/@value').try(:value))
                set_model_data(model, 'start', entry.at_xpath('./fhir:start/@value').try(:value))
                set_model_data(model, 'end', entry.at_xpath('./fhir:end/@value').try(:value))
                model
            end
        end
    end
end
