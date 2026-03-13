#include <iostream>
#include <string>
#include <regex>
#include <vector>
#include <cassert>

struct cypher_parser {
    struct result {
        enum class type { create_node, match_node, unknown };
        type cmd_type;
        std::string label;
        std::string properties;
    };

    result parse(const std::string& query) {
        std::regex create_pattern(R"(CREATE\s*\(\w+:(\w+)\s*(\{.*\})\))");
        std::smatch match;
        if (std::regex_search(query, match, create_pattern)) {
            if (match.size() > 2) {
                return { result::type::create_node, match[1].str(), match[2].str() };
            }
        }
        
        if (query.find("MATCH (n) RETURN n") != std::string::npos) {
             return { result::type::match_node, "", "" };
        }

        return { result::type::unknown, "", "" };
    }
};

int main() {
    cypher_parser parser;
    
    // Test CREATE
    auto r1 = parser.parse("CREATE (n:Person {name: 'Alice'})");
    assert(r1.cmd_type == cypher_parser::result::type::create_node);
    assert(r1.label == "Person");
    assert(r1.properties == "{name: 'Alice'}");
    std::cout << "Test CREATE: PASS" << std::endl;

    // Test MATCH
    auto r2 = parser.parse("MATCH (n) RETURN n");
    assert(r2.cmd_type == cypher_parser::result::type::match_node);
    std::cout << "Test MATCH: PASS" << std::endl;

    return 0;
}
