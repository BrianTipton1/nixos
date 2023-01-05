{
  home.file.".ghci/ghci.conf".text = ''
    :set -interactive-print=Text.Pretty.Simple.pPrint
    :set prompt "\ESC[34m\STX λ: \ESC[m\STX"
    :set prompt-cont "\ESC[34m\STX λ| \ESC[m\STX"

    -- useful flags
    :set -fprint-explicit-foralls
    :set +m

    -- useful extensions by default
    :set -XTypeApplications -XKindSignatures
  '';
}
