{application,start_wrap,
             [{description,"Make it possible to boot a release with non-OTP code"},
              {registered,[start_wrap]},
              {vsn,"1.0.0"},
              {applications,[kernel,stdlib]},
              {mod,{start_wrap,[]}},
              {env,[]},
              {modules,[start_wrap,start_wrap_bridge,start_wrap_sup]}]}.
