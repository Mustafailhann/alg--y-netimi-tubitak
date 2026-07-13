using System;
using System.Collections.Generic;
using RealityLens.Domain.Common;

namespace RealityLens.Domain.ValueObjects;

public class JoinCode : ValueObject
{
    public string Value { get; private set; }

    private JoinCode() 
    { 
        Value = string.Empty; 
    } // Required for EF Core serialization

    public JoinCode(string value)
    {
        if (string.IsNullOrWhiteSpace(value) || value.Length != 6)
        {
            throw new ArgumentException("Join code must be exactly 6 characters.");
        }
        Value = value.ToUpper();
    }

    protected override IEnumerable<object?> GetEqualityComponents()
    {
        yield return Value;
    }

    public override string ToString()
    {
        return Value;
    }
}
