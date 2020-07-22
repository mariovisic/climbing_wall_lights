class Route < Sequel::Model
  DIFFICULTIES = {
    0 => 'Not Rated',
    1 => 'Very easy',
    2 => 'Easy',
    3 => 'Medium',
    4 => 'Difficult',
    5 => 'Very Difficult',
    6 => 'Ridiculous'
  }
end
