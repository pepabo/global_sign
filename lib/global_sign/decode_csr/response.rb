module GlobalSign
  module DecodeCsr
    class Response < GlobalSign::Response
      module XPath
        CSRData             = '//Response/CSRData'
        CertificatePreview  = '//Response/CertificatePreview'
      end

      def params
        @params ||= {
          csr_data: detail(@xml.xpath(XPath::CSRData)),
          certificate_preview: detail(@xml.xpath(XPath::CertificatePreview))
        }
      end

      private

      def detail(data)
        {
          common_name:       data.at('CommonName')   ? data.at('CommonName').text : '',
          organization:      data.at('Organization') ? data.at('Organization').text : '',
          organization_unit: data.at('Organization') ? data.at('OrganizationUnit').text : '',
          locality:          data.at('Locality')     ? data.at('Locality').text : '',
          state:             data.at('State')        ? data.at('State').text : '',
          country:           data.at('Country')      ? data.at('Country').text : '',
          email_address:     data.at('EmailAddress') ? data.at('EmailAddress').text : '',
          key_length:        data.at('KeyLength')    ? data.at('KeyLength').text : ''
        }
      end
    end
  end
end
