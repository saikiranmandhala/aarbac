#region Copyright Notice
/* Copyright (c) 2017, Deb'jyoti Das - debjyoti@debjyoti.com
 All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are not permitted.Neither the name of the 
 'Deb'jyoti Das' nor the names of its contributors may be used 
 to endorse or promote products derived from this software without 
 specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY Deb'jyoti Das 'AS IS' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL Synechron Holdings Inc BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#region Developer Information
/*
Author  - Debjyoti Das (debjyoti@debjyoti.com)
Created - 11/12/2017 3:31:31 PM
Description  - 
Modified By - 
Description  - 
*/
#endregion Developer Information

#endregion Copyright Notice
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace Eyedia.Aarbac.Framework
{
    public partial class SqlQueryParser
    {       

        public void ApplyPermissionInsert()
        {
            var tables = Columns.List.GroupBy(c => c.ReferencedTableName).Select(grp => grp.ToList()).ToList();
            foreach (var allColumnnsInATable in tables)
            {
                if (allColumnnsInATable.Count > 0)
                {
                    RbacTable rbacTable = TablesReferred.Find(allColumnnsInATable[0].ReferencedTableName);
                    if (rbacTable == null)
                        throw new Exception("Could not find table name in referred tables!");
                    if (rbacTable.AllowedOperations.HasFlag(RbacDBOperations.Create))
                    {
                        foreach (RbacSelectColumn column in allColumnnsInATable)
                        {
                            RbacColumn rbacColumn = rbacTable.FindColumn(column.TableColumnName);
                            if (!rbacColumn.AllowedOperations.HasFlag(RbacDBOperations.Create))
                                RbacException.Raise(string.Format("User '{0}' has permission to insert record into the table '{1}', however has no permission to insert values into column '{2}'!",
                                    Context.User.UserName, rbacTable.Name, rbacColumn.Name), RbacExceptionCategories.Parser);
                        }
                    }
                    else
                    {
                        RbacException.Raise(string.Format("User '{0}' does not have permission to insert record into the table '{1}'!",
                                    Context.User.UserName, rbacTable.Name), RbacExceptionCategories.Parser);
                    }
                }
            }

            IsPermissionApplied = true;
        }
        
    }
}

