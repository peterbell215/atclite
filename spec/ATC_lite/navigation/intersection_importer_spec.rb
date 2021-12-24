# frozen_string_literal: true

require 'rspec'

RSpec.describe ATCLite::Navigation::IntersectionImporter do
  describe '::parse_navs_file' do
    subject(:guvri) do
      ATCLite::Navigation::Intersection.lookup('GUVRI', Coordinate.new(latitude: 38.0, longitude: 115.0))
    end

    # rubocop: disable RSpec/BeforeAfterAll the data is read in read-only so no danger of state
    #                                       leakage.  Its a large data file so reading once rather
    #                                       than for every test is better.
    before(:all) { described_class.parse_ints_file }
    # rubocop: enable RSpec/BeforeAfterAll

    specify { expect(guvri.latitude).to eq 38.497778 }
    specify { expect(guvri.longitude).to eq 115.700000 }
  end

  describe '::navs_line' do
    context 'when its an Intersection in Europe' do
      subject(:nav_hash) do
        described_class.navs_line('GUVRI  GUVRI  38.497778  115.700000 EEU', 1)
      end

      specify { expect(nav_hash[:name]).to eq 'GUVRI' }
      specify { expect(nav_hash[:alternate_name]).to eq 'GUVRI' }
      specify { expect(nav_hash[:latitude]).to eq '38.497778' }
      specify { expect(nav_hash[:longitude]).to eq '115.700000' }
      specify { expect(nav_hash[:region]).to eq 'EEU' }
    end

    context 'when it is an Intersection without region' do
      subject(:nav_hash) do
        described_class.navs_line('4878N  4878N  48.000000  -78.000000   ', 1)
      end

      specify { expect(nav_hash[:name]).to eq '4878N' }
      specify { expect(nav_hash[:alternate_name]).to eq '4878N' }
      specify { expect(nav_hash[:latitude]).to eq '48.000000' }
      specify { expect(nav_hash[:longitude]).to eq '-78.000000' }
      specify { expect(nav_hash[:region]).to be_nil }
    end
  end
end