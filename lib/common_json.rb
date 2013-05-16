# Copyright (C) 2011,2012,2013 American Registry for Internet Numbers
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
# IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

require 'config'
require 'nicinfo_logger'
require 'utils'

module NicInfo

  # deals with common JSON RDAP structures
  class CommonJson

    def initialize config
      @config = config
    end

    def display_remarks objectclass
      remarks = objectclass[ "remarks" ]
      if (Notices::is_excessive_notice remarks) && (@config.logger.data_amount != NicInfo::DataAmount::EXTRA_DATA)
        @config.logger.datum "Excessive Remarks", "Use \"-V\" or \"--data extra\" to see them."
      else
        remarks.each do |remark|
          title = remark[ "title" ]
          @config.logger.datum "Remarks", "-- #{title} --" if title
          descriptions = NicInfo::get_descriptions remark
          i = 1
          descriptions.each do |line|
            if !title && i == 1
              @config.logger.datum "Remarks", line
            elsif i != 1 || title
              @config.logger.datum i.to_s, line
            end
            i = i + 1
          end
        end if remarks
      end
    end

  end

end