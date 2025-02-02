# SPDX-License-Identifier: Apache-2.0
#
# The OpenSearch Contributors require contributions made to
# this file be licensed under the Apache-2.0 license or a
# compatible open source license.
#
# Modifications Copyright OpenSearch Contributors. See
# GitHub history for details.
#
# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe OpenSearch::DSL::Search::Aggregations::Filters do

  let(:search) do
    described_class.new
  end

  describe '#to_hash' do

    it 'can be converted to a hash' do
      expect(search.to_hash).to eq(filters: {})
    end
  end

  context 'when options methods are called' do

    let(:search) do
      described_class.new
    end

    describe '#filters' do

      before do
        search.filters(foo: 'bar')
      end

      it 'applies the option' do
        expect(search.to_hash[:filters][:filters][:foo]).to eq('bar')
      end
    end
  end

  context '#initialize' do

    let(:search) do
      described_class.new(foo: 'bar')
    end

    it 'takes a hash' do
      expect(search.to_hash).to eq(filters: { foo: 'bar' })
    end

    context 'when filters are passed' do

      let(:search) do
        described_class.new(filters: { foo: 'bar' })
      end

      it 'defines filters' do
        expect(search.to_hash).to eq(filters: { filters: { foo: 'bar' } })
      end
    end
  end

  context 'when another aggregation is nested' do

    let(:search) do
      described_class.new do
        filters foo: { terms: { foo: 'bar' } }
        aggregation :sum_clicks do
          sum moo: 'bam'
        end
      end
    end

    it 'nests the aggregation in the hash' do
      expect(search.to_hash).to eq(filters: { filters: { foo: { terms: { foo: 'bar' } } } },
                                   aggregations: { sum_clicks: { sum: { moo: 'bam' } } })
    end
  end
end
