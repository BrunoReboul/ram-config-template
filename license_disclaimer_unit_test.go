// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the 'License');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package main

import (
	"bytes"
	"io/ioutil"
	"os"
	"path/filepath"
	"testing"
)

// GODisclaimer text to be added on top of GO files
const GODisclaimer = `// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the 'License');
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an 'AS IS' BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
`

// REGODisclaimer text to be added on top of REGO files
const REGODisclaimer = `# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
`

// YAMLDisclaimer text to be added on top of YAML files
const YAMLDisclaimer = `# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
`

func TestUnitDisclaimer(t *testing.T) {
	err := filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		t.Run(filepath.Base(path), func(t *testing.T) {
			t.Parallel()
			if err != nil {
				t.Fatal(err)
			}
			var disclaimer string
			switch filepath.Ext(path) {
			case ".go":
				disclaimer = GODisclaimer
			case ".rego":
				disclaimer = REGODisclaimer
			case ".yaml":
				disclaimer = YAMLDisclaimer
			default:
				disclaimer = ""
			}
			if disclaimer != "" {
				sourceCode, err := ioutil.ReadFile(path)
				if err != nil {
					t.Fatal(err)
				}
				// Check the source code starts with the license and disclaimer header
				if !bytes.HasPrefix(sourceCode, []byte(disclaimer)) {
					t.Errorf("%v: license and disclaimer header not found on first line", path)
				}
			}
		})
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
}
