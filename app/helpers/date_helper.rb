# encoding: utf-8
module DateHelper
  
  MONTHS = %w{
    Januar
    Februar
    März
    April
    Mai
    Juni
    Juli
    August
    September
    Oktober
    November
    Dezember
  }
  
  def format_date(date)
    "#{date.mday}. #{MONTHS[date.month - 1]} #{date.year}"
  end
    
end