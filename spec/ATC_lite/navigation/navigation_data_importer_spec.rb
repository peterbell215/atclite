require 'rspec'

RSpec.describe ATCLite::Navigation::NavigationDataImporter do
  describe '::parse_navs_file' do
    subject(:bnn) do
      ATCLite::Navigation::RadioNavigationAidImporter.parse_navs_file
      ATCLite::Navigation::RadioNavigationAid.lookup('BNN', Coordinate.new(latitude: 51.0, longitude: 0.0))
    end

    specify { expect(bnn.frequency).to eq '113.75' }
    specify { expect(bnn.latitude).to eq 51.726164 }
    specify { expect(bnn.longitude).to eq -0.549750 }
  end

  describe '::navs_line' do
    context 'when its a VOR in Europe' do
      subject(:nav_hash) do
        ATCLite::Navigation::RadioNavigationAidImporter.navs_line('BNN  BOVINGDON   51.726164  -0.549750  VOR 113.75 EUR', 1)
      end

      specify { expect(nav_hash[:name]).to eq 'BNN' }
      specify { expect(nav_hash[:fullname]).to eq 'BOVINGDON' }
      specify { expect(nav_hash[:frequency]).to eq '113.75' }
      specify { expect(nav_hash[:latitude]).to eq '51.726164' }
      specify { expect(nav_hash[:longitude]).to eq '-0.549750' }
      specify { expect(nav_hash[:region]).to eq 'EUR' }
    end

    context 'when it is an NDB in Canada' do
      subject(:nav_hash) do
        ATCLite::Navigation::RadioNavigationAidImporter.navs_line("1B  SABLE_ISLAND  43.930556   -60.022778   NDB 277.00 CAN", 1)
      end

      specify { expect(nav_hash[:name]).to eq '1B' }
      specify { expect(nav_hash[:fullname]).to eq 'SABLE_ISLAND' }
      specify { expect(nav_hash[:frequency]).to eq '277.00' }
      specify { expect(nav_hash[:latitude]).to eq '43.930556' }
      specify { expect(nav_hash[:longitude]).to eq '-60.022778' }
      specify { expect(nav_hash[:region]).to eq 'CAN' }
    end

    context 'when the line is misformed' do
      let(:misformed_input) { '1BBB  SABLE_ISLAND  43.930556    -60.022778    NDB A77.00 CAN' }
      let(:error_offset) {    '                                                   '.size }

      it 'sends an appropriate error message to stderr' do
        expect { ATCLite::Navigation::RadioNavigationAidImporter.navs_line(misformed_input, 1) }
          .to output("#{misformed_input}\n#{' ' * error_offset}^Mis-formed frequency on line 1\n").to_stderr
      end
    end
  end
end
