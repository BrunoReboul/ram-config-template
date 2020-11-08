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
	"fmt"
	"io/ioutil"
	"os"
	"sort"
	"strings"
	"testing"

	"github.com/BrunoReboul/ram/utilities/ramcli"
)

const readmeName = "readme.md"

func TestUnitConstraintsReadme(t *testing.T) {
	constraintFolderRelativePaths, err := ramcli.GetConstraintFolderRelativePaths("./")
	if err != nil {
		t.Fatal(err)
	}
	sort.Strings(constraintFolderRelativePaths)
	for _, constraintFolderRelativePath := range constraintFolderRelativePaths {
		constraintFolderRelativePath := constraintFolderRelativePath // https://github.com/golang/go/wiki/CommonMistakes#using-goroutines-on-loop-iterator-variables
		t.Run(constraintFolderRelativePath, func(t *testing.T) {
			t.Parallel()
			path := fmt.Sprintf("%s/%s", constraintFolderRelativePath, readmeName)
			_, err := os.Stat(path)
			if os.IsNotExist(err) {
				t.Errorf("Want readme file and did not find it %s", path)
			} else {
				if err != nil {
					t.Fatal(err)
				}
				bytes, err := ioutil.ReadFile(path)
				if err != nil {
					t.Fatal(err)
				}
				content := string(bytes)
				if !strings.Contains(content, "## Background\n") {
					t.Errorf("Want '## Background\n' level 2 header and did not find it %s", path)
				}
				if !strings.Contains(content, "## Background\n") {
					t.Errorf("Want '## Fix\n' level 2 header and did not find it %s", path)
				}
				if !strings.Contains(content, "## References\n") {
					t.Errorf("Want '## References\n' level 2 header and did not find it %s", path)
				}
			}
		})
	}
}
