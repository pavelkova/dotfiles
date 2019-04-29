const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#091f2c", /* black   */
  [1] = "#d07c67", /* red     */
  [2] = "#617c42", /* green   */
  [3] = "#797543", /* yellow  */
  [4] = "#30a490", /* blue    */
  [5] = "#ae7583", /* magenta */
  [6] = "#488776", /* cyan    */
  [7] = "#ecccc2", /* white   */

  /* 8 bright colors */
  [8]  = "#203a3e",  /* black   */
  [9]  = "#e6958b",  /* red     */
  [10] = "#9CA259", /* green   */
  [11] = "#cac46e", /* yellow  */
  [12] = "#8abeb7", /* blue    */
  [13] = "#bc94a3", /* magenta */
  [14] = "#b2d5b7", /* cyan    */
  [15] = "#fefef7", /* white   */

  /* special colors */
  [256] = "#091f2c", /* background */
  [257] = "#fefef7", /* foreground */
  [258] = "#fefef7",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;
