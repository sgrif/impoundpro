States = {
      'AL' => 'Alabama',
      'AK' => 'Alaska',
      'AS' => 'America Samoa',
      'AZ' => 'Arizona',
      'AR' => 'Arkansas',
      'CA' => 'California',
      'CO' => 'Colorado',
      'CT' => 'Connecticut',
      'DE' => 'Delaware',
      'DC' => 'District of Columbia',
      'FM' => 'Micronesia1',
      'FL' => 'Florida',
      'GA' => 'Georgia',
      'GU' => 'Guam',
      'HI' => 'Hawaii',
      'ID' => 'Idaho',
      'IL' => 'Illinois',
      'IN' => 'Indiana',
      'IA' => 'Iowa',
      'KS' => 'Kansas',
      'KY' => 'Kentucky',
      'LA' => 'Louisiana',
      'ME' => 'Maine',
      'MH' => 'Islands1',
      'MD' => 'Maryland',
      'MA' => 'Massachusetts',
      'MI' => 'Michigan',
      'MN' => 'Minnesota',
      'MS' => 'Mississippi',
      'MO' => 'Missouri',
      'MT' => 'Montana',
      'NE' => 'Nebraska',
      'NV' => 'Nevada',
      'NH' => 'New Hampshire',
      'NJ' => 'New Jersey',
      'NM' => 'New Mexico',
      'NY' => 'New York',
      'NC' => 'North Carolina',
      'ND' => 'North Dakota',
      'OH' => 'Ohio',
      'OK' => 'Oklahoma',
      'OR' => 'Oregon',
      'PW' => 'Palau',
      'PA' => 'Pennsylvania',
      'PR' => 'Puerto Rico',
      'RI' => 'Rhode Island',
      'SC' => 'South Carolina',
      'SD' => 'South Dakota',
      'TN' => 'Tennessee',
      'TX' => 'Texas',
      'UT' => 'Utah',
      'VT' => 'Vermont',
      'VI' => 'Virgin Island',
      'VA' => 'Virginia',
      'WA' => 'Washington',
      'WV' => 'West Virginia',
      'WI' => 'Wisconsin',
      'WY' => 'Wyoming',
      'AA' => 'Armed Forces (AA)',
      'AE' => 'Armed Forces (AE)',
      'AP' => 'Armed Forces (AP)',
      'MP' => 'Northern Mariana Islands'
    }

Sizes = [
  '2-Door',
  '4-Door',
  'SUV',
  'Pickup',
  'Van',
  'RV',
  'Trailer',
  'ATV',
  'Other'
]

CheckVin = {
  :weights => [ 8, 7, 6, 5, 4, 3, 2, 10, 0, 9, 8, 7, 6, 5, 4, 3, 2 ],
  :char_trans => {
    'A' => 1, 'B' => 2, 'C' => 3, 'D' => 4, 'E' => 5, 'F' => 6,   'G' => 7, 'H' => 8,   'I' => nil,
    'J' => 1, 'K' => 2, 'L' => 3, 'M' => 4, 'N' => 5, 'O' => nil, 'P' => 7, 'Q' => nil, 'R' => 9,
              'S' => 2, 'T' => 3, 'U' => 4, 'V' => 5, 'W' => 6,   'X' => 7, 'Y' => 8,   'Z' => 9,
    '1' => 1, '2' => 2, '3' => 3, '4' => 4, '5' => 5, '6' => 6,   '7' => 7, '8' => 8,   '9' => 9,   '0' => 0,
  },
  :misreads => { 'O' => 0, 'Q' => 0, 'I' => 1 },
}
