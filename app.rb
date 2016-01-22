require 'sinatra'
require 'slim'
require 'slim/include'
require 'rack-ssl-enforcer'
require 'json'
require 'yaml'

# The Nigerian Budget visualizer
class ViewTheBudget < Sinatra::Base
  summary_by_mda = YAML.load File.read('./data/summary_by_mda.yml')

  summary_by_mda = summary_by_mda.map do |mda, values|
    mda = mda.split.map do |word|
      if %w(of the and).include? word.downcase then word.downcase
      else word.capitalize
      end
    end.join(' ')
    [mda, values]
  end.to_h

  column_by_mda = summary_by_mda.map do |mda, values|
    [mda, [values[2], values[3]]]
  end.to_h

  total_recurrent = summary_by_mda.map { |_, values| values[2] }.reduce(:+)
  total_capital = summary_by_mda.map { |_, values| values[3] }.reduce(:+)

  pie_by_mda = summary_by_mda.map do |mda, values|
    arr = [values[2], values[3]].map.each_with_index do |elem, idx|
      if idx == 0 then (elem.to_f / total_recurrent * 100).round 2
      else (elem.to_f / total_capital * 100).round 2
      end
    end
    [mda, arr]
  end.to_h

  get '/' do
    slim :index, locals: {
      mda_column: column_by_mda, mda_pie: pie_by_mda,
      mda_total_recurrent: total_recurrent, mda_total_capital: total_capital
    }
  end
end
