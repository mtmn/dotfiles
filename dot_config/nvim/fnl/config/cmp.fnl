(fn config []
  (let [cmp (require :cmp)]
    (cmp.setup {:snippet {:expand (fn [args]
                                    ((. (require :luasnip)
                                        :lsp_expand) args.body))}
                :window {:completion {:winhighlight "Normal:CmpNormal"}
                         :documentation {:winhighlight "Normal:CmpNormal"}}
                :mapping (cmp.mapping.preset.insert {:ctrl-b (cmp.mapping.scroll_docs -4)
                                                     :ctrl-f (cmp.mapping.scroll_docs 4)
                                                     :ctrl-space (cmp.mapping.complete)
                                                     :ctrl-e (cmp.mapping.abort)
                                                     :enter (cmp.mapping.confirm {:select true})})
                :sources (cmp.config.sources [{:name :nvim_lsp}
                                              {:name :luasnip}
                                              {:name :path}]
                                             [{:name :buffer}])})))

{: config}
