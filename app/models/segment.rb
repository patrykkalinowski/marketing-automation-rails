class Segment < ActiveRecord::Base
  serialize :filters

  has_and_belongs_to_many :users

  validates :filters, presence: true

  def build
    segment_builder = BuildSegment.new(self)
    segment_builder.call
  end

  def self.build_all
    Segment.all.each do |segment|
      segment_builder = BuildSegment.new(segment)
      segment_builder.call
    end
  end

  def self.example2
    # segment has many filters
    # filters have many rules
    # rules have many hashes of parameters (type, url, title etc)
    # serialize filters

    filters = [
      [
        { name: "$view",
          match: "^",
          properties: {
            page: '/messages',
          }
        }, # AND
      ]
    ]

    Segment.create(filters: filters)
  end
  def self.example
    # segment has many filters
    # filters have many rules
    # rules have many hashes of parameters (type, url, title etc)
    # serialize filters

    filters = [
      [
        { name: "$view",
          match: "^",
          properties: {
            page: '/messages',
          }
        }, # AND
        { name: "$view",
          match: "$",
          properties: {
            page: '1',
          }
        }
      ], # OR
      [
        { name: "$view",
          match: "!",
          properties: {
            page: '/messages/1',
          }
        }
      ], # OR
      [
        { name: "$view",
          match: "~",
          properties: {
            url: 'param=test',
          }
        }
      ], # OR
      [
        { name: "$email",
          match: "~",
          properties: {
            subject: "Example Message"
          },
        }, # AND
        {
          name: "$email",
          match: "#",
          properties: {
            to: "patryk.kalinowski"
          }
        }
      ]
    ]

    Segment.create(filters: filters)
  end
end
