require 'nokogiri'

module GlobalSign
  class RequestXmlBuilder
    module XmlNamespace
      BODY = 'http://schemas.xmlsoap.org/soap/envelope/'.freeze
      ACTION = 'https://system.globalsign.com/kb/ws/v1/'.freeze
    end

    class << self
      def build_xml(action:, params:)
        xml = xml_envelope(action).at('//Request') << xml_body(params).root.elements

        builder = Nokogiri::XML::Builder.with(xml)
        builder.doc.root.to_xml
      end

      def xml_envelope(action)
        Nokogiri::XML(
          <<-EOS
<soap:Envelope xmlns:soap=\"#{XmlNamespace::BODY}\" xmlns:ns2=\"#{XmlNamespace::ACTION}\">
  <soap:Body>
    <ns2:#{action}>
      <Request/>
    </ns2:#{action}>
  </soap:Body>
</soap:Envelope>
          EOS
        ) do |configuration|
          configuration.default_xml.noblanks
        end
      end

      def xml_body(params)
        Nokogiri.XML(params.to_xml) do |configuration|
          configuration.default_xml.noblanks
        end
      end
    end
  end
end
