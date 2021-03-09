// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include <stdlib.h>

void reverse(char *str)
{
   // Calculate length.
   int l = 0;
   while (*(str + l) != '\0')
      l++;

   // Initialize;
   int i;
   char *first, *last, temp;
   first = str;
   last = str;
   for (i = 0; i < l - 1; i++)
   {
      last++;
   }

   // Iterate from both ends, swapping as we go.
   for (i = 0; i < l / 2; i++)
   {
      temp = *last;
      *last = *first;
      *first = temp;

      first++;
      last--;
   }
}
