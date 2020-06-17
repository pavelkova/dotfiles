static const char norm_fg[] = "#fefef7";
static const char norm_bg[] = "#091f2c";
static const char norm_border[] = "#203a3e";

static const char sel_fg[] = "#fefef7";
static const char sel_bg[] = "#617c42";
static const char sel_border[] = "#fefef7";

static const char urg_fg[] = "#fefef7";
static const char urg_bg[] = "#d07c67";
static const char urg_border[] = "#d07c67";

static const char *colors[][3]      = {
    /*               fg           bg         border                         */
    [SchemeNorm] = { norm_fg,     norm_bg,   norm_border }, // unfocused wins
    [SchemeSel]  = { sel_fg,      sel_bg,    sel_border },  // the focused win
    [SchemeUrg] =  { urg_fg,      urg_bg,    urg_border },
};
